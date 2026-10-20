#ifndef _GL4ES_SPVCONV_H_
#define _GL4ES_SPVCONV_H_

#ifdef __cplusplus
extern "C" {
#endif

/*
 * GLSL -> SPIR-V (glslang) -> ESSL (SPIRV-Cross).
 *
 * source     : GLSL that glslang can compile for SPIR-V, i.e. desktop >= 330 core
 *              or ES >= 310 (legacy shaders must be lowered first, see
 *              ConvertShaderSpv() in vgpu/shaderconv.c).
 * isVertex   : 1 for a vertex shader, 0 for a fragment shader.
 * esVersion  : target ESSL version: 100, 300, 310 or 320.
 * highp      : 1 if highp is available in fragment shaders.
 * errlog     : (optional) receives a malloc'ed log on failure, caller frees.
 *
 * returns a malloc'ed ESSL source, or NULL on failure.
 */
char* spvconv_glsl_to_essl(const char* source, int isVertex, int esVersion, int highp, char** errlog);

#ifdef __cplusplus
}
#endif

#endif // _GL4ES_SPVCONV_H_
