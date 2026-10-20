// GLSL -> SPIR-V -> ESSL conversion backend.
//
// glslang is used directly (no shaderc / SPIRV-Tools: no optimizer, no validator),
// SPIRV-Cross is used for the GLSL ES backend only. This keeps the binary small
// and the conversion fast, the heavy lifting being done by the two parsers.

#include <cstdlib>
#include <cstring>
#include <exception>
#include <mutex>
#include <string>
#include <vector>

#include "glslang/Public/ShaderLang.h"
#include "glslang/Public/ResourceLimits.h"
#include "SPIRV/GlslangToSpv.h"
#include "spirv_glsl.hpp"

#include "spvconv.h"

namespace {

std::mutex g_lock;
bool g_inited = false;

char* dupstr(const std::string& s) {
    char* r = (char*)malloc(s.size() + 1);
    if (r) memcpy(r, s.c_str(), s.size() + 1);
    return r;
}

void fail(char** errlog, const std::string& msg) {
    if (errlog) *errlog = dupstr(msg);
}

// Remove the layout decorations that glslang auto-assigned (it has to, loose uniforms
// need a location in SPIR-V for OpenGL) so that the emitted ESSL keeps relying on
// glBindAttribLocation / glGetUniformLocation / name based varying matching, exactly
// like the original GLSL did. Decorations explicitly written by the shader are
// kept (explicitLayouts), except for loose uniforms, where auto-mapping is per stage
// and would produce mismatching locations at link time.
void sanitize_layouts(spirv_cross::CompilerGLSL& comp, bool explicitLayouts, bool bindingsOk) {
    using namespace spirv_cross;
    ShaderResources res = comp.get_shader_resources();

    auto strip = [&](const SmallVector<Resource>& list, bool loc, bool bind) {
        for (auto& r : list) {
            if (loc)  comp.unset_decoration(r.id, spv::DecorationLocation);
            if (bind) {
                comp.unset_decoration(r.id, spv::DecorationBinding);
                comp.unset_decoration(r.id, spv::DecorationDescriptorSet);
            }
        }
    };

    // vertex inputs / fragment outputs (glBindAttribLocation, glBindFragDataLocation)
    // and the other stage interface: only keep when written by the author.
    strip(res.stage_inputs,  !explicitLayouts, false);
    strip(res.stage_outputs, !explicitLayouts, false);

    // loose uniforms and opaque types
    strip(res.sampled_images,  true, !explicitLayouts || !bindingsOk);
    strip(res.separate_images, true, !explicitLayouts || !bindingsOk);
    strip(res.separate_samplers, true, !explicitLayouts || !bindingsOk);
    strip(res.storage_images,  true, !explicitLayouts || !bindingsOk);
    strip(res.atomic_counters, true, !explicitLayouts || !bindingsOk);
    strip(res.uniform_buffers, false, !explicitLayouts || !bindingsOk);
    strip(res.storage_buffers, false, !explicitLayouts || !bindingsOk);

    // loose (non opaque) uniforms
    strip(res.gl_plain_uniforms, true, true);
}

} // namespace

extern "C" char* spvconv_glsl_to_essl(const char* source, int isVertex, int esVersion, int highp, char** errlog) {
    if (errlog) *errlog = nullptr;
    if (!source) return nullptr;

    std::lock_guard<std::mutex> lock(g_lock);
    if (!g_inited) {
        glslang::InitializeProcess();
        g_inited = true;
    }

    const EShLanguage stage = isVertex ? EShLangVertex : EShLangFragment;
    const EShMessages msgs = (EShMessages)(EShMsgSpvRules | EShMsgSuppressWarnings);

    std::vector<unsigned int> spirv;
    {
        glslang::TShader shader(stage);
        shader.setStrings(&source, 1);
        shader.setEnvInput(glslang::EShSourceGlsl, stage, glslang::EShClientOpenGL, 100);
        shader.setEnvClient(glslang::EShClientOpenGL, glslang::EShTargetOpenGL_450);
        shader.setEnvTarget(glslang::EShTargetSpv, glslang::EShTargetSpv_1_0);
        shader.setAutoMapLocations(true);

        if (!shader.parse(GetDefaultResources(), 450, false, msgs)) {
            fail(errlog, std::string("glslang parse: ") + shader.getInfoLog() + shader.getInfoDebugLog());
            return nullptr;
        }

        glslang::TProgram program;
        program.addShader(&shader);
        if (!program.link(msgs)) {
            fail(errlog, std::string("glslang link: ") + program.getInfoLog() + program.getInfoDebugLog());
            return nullptr;
        }

        glslang::TIntermediate* im = program.getIntermediate(stage);
        if (!im) {
            fail(errlog, "glslang: no intermediate");
            return nullptr;
        }

        glslang::SpvOptions so;
        so.disableOptimizer = true;
        so.validate = false;
        so.generateDebugInfo = false;
        so.stripDebugInfo = false; // names must survive: uniforms/attribs are looked up by name
        glslang::GlslangToSpv(*im, spirv, &so);
    }

    try {
        spirv_cross::CompilerGLSL comp(std::move(spirv));

        spirv_cross::CompilerGLSL::Options opts = comp.get_common_options();
        opts.es = true;
        opts.version = (uint32_t)esVersion;
        opts.vulkan_semantics = false;
        opts.enable_420pack_extension = false;
        opts.relax_nan_checks = true;
        opts.emit_uniform_buffer_as_plain_uniforms = esVersion < 300;
        opts.fragment.default_float_precision = highp ? spirv_cross::CompilerGLSL::Options::Highp
                                                      : spirv_cross::CompilerGLSL::Options::Mediump;
        opts.fragment.default_int_precision = spirv_cross::CompilerGLSL::Options::Highp;
        comp.set_common_options(opts);

        // explicit layouts written in the (lowered) source are honoured
        const bool explicitLayouts = strstr(source, "location") != nullptr;
        sanitize_layouts(comp, explicitLayouts, esVersion >= 310);

        std::string out = comp.compile();
        return dupstr(out);
    } catch (const std::exception& e) {
        fail(errlog, std::string("SPIRV-Cross: ") + e.what());
    } catch (...) {
        fail(errlog, "SPIRV-Cross: unknown error");
    }
    return nullptr;
}
