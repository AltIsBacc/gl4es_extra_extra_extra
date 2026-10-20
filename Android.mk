LOCAL_PATH := $(call my-dir)

###########################
#
# GL static library
#
###########################

include $(CLEAR_VARS)

LOCAL_MODULE := gl4es_114

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_C_INCLUDES += $(LOCAL_PATH)/third_party/glslang $(LOCAL_PATH)/third_party/SPIRV-Cross $(LOCAL_PATH)/src/gl/spvconv $(LOCAL_PATH)/src/gl/spvconv/include

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_C_INCLUDES) -DBCMHOST

LOCAL_SRC_FILES := \
	third_party/glslang/glslang/GenericCodeGen/CodeGen.cpp \
	third_party/glslang/glslang/GenericCodeGen/Link.cpp \
	third_party/glslang/glslang/OSDependent/Unix/ossource.cpp \
	third_party/glslang/glslang/ResourceLimits/ResourceLimits.cpp \
	third_party/glslang/glslang/MachineIndependent/attribute.cpp \
	third_party/glslang/glslang/MachineIndependent/Constant.cpp \
	third_party/glslang/glslang/MachineIndependent/iomapper.cpp \
	third_party/glslang/glslang/MachineIndependent/InfoSink.cpp \
	third_party/glslang/glslang/MachineIndependent/Initialize.cpp \
	third_party/glslang/glslang/MachineIndependent/IntermTraverse.cpp \
	third_party/glslang/glslang/MachineIndependent/Intermediate.cpp \
	third_party/glslang/glslang/MachineIndependent/ParseContextBase.cpp \
	third_party/glslang/glslang/MachineIndependent/ParseHelper.cpp \
	third_party/glslang/glslang/MachineIndependent/PoolAlloc.cpp \
	third_party/glslang/glslang/MachineIndependent/RemoveTree.cpp \
	third_party/glslang/glslang/MachineIndependent/Scan.cpp \
	third_party/glslang/glslang/MachineIndependent/ShaderLang.cpp \
	third_party/glslang/glslang/MachineIndependent/SpirvIntrinsics.cpp \
	third_party/glslang/glslang/MachineIndependent/SymbolTable.cpp \
	third_party/glslang/glslang/MachineIndependent/Versions.cpp \
	third_party/glslang/glslang/MachineIndependent/intermOut.cpp \
	third_party/glslang/glslang/MachineIndependent/limits.cpp \
	third_party/glslang/glslang/MachineIndependent/linkValidate.cpp \
	third_party/glslang/glslang/MachineIndependent/parseConst.cpp \
	third_party/glslang/glslang/MachineIndependent/reflection.cpp \
	third_party/glslang/glslang/MachineIndependent/propagateNoContraction.cpp \
	third_party/glslang/glslang/MachineIndependent/glslang_tab.cpp \
	third_party/glslang/glslang/MachineIndependent/preprocessor/Pp.cpp \
	third_party/glslang/glslang/MachineIndependent/preprocessor/PpAtom.cpp \
	third_party/glslang/glslang/MachineIndependent/preprocessor/PpContext.cpp \
	third_party/glslang/glslang/MachineIndependent/preprocessor/PpScanner.cpp \
	third_party/glslang/glslang/MachineIndependent/preprocessor/PpTokens.cpp \
	third_party/glslang/SPIRV/GlslangToSpv.cpp \
	third_party/glslang/SPIRV/InReadableOrder.cpp \
	third_party/glslang/SPIRV/Logger.cpp \
	third_party/glslang/SPIRV/SpvBuilder.cpp \
	third_party/glslang/SPIRV/SpvPostProcess.cpp \
	third_party/glslang/SPIRV/doc.cpp \
	third_party/glslang/SPIRV/SpvTools.cpp \
	third_party/glslang/SPIRV/disassemble.cpp \
	third_party/SPIRV-Cross/spirv_cross.cpp \
	third_party/SPIRV-Cross/spirv_cfg.cpp \
	third_party/SPIRV-Cross/spirv_cross_parsed_ir.cpp \
	third_party/SPIRV-Cross/spirv_parser.cpp \
	third_party/SPIRV-Cross/spirv_glsl.cpp \
	src/gl/spvconv/spvconv.cpp \
	src/gl/arbconverter.c \
	src/gl/arbgenerator.c \
	src/gl/arbhelper.c \
	src/gl/arbparser.c \
	src/gl/array.c \
	src/gl/blend.c \
	src/gl/blit.c \
	src/gl/buffers.c \
	src/gl/build_info.c \
	src/gl/debug.c \
	src/gl/decompress.c \
	src/gl/depth.c \
	src/gl/directstate.c \
	src/gl/drawing.c \
	src/gl/enable.c \
	src/gl/envvars.c \
	src/gl/eval.c \
	src/gl/face.c \
	src/gl/fog.c \
	src/gl/fpe.c \
	src/gl/fpe_cache.c \
	src/gl/fpe_shader.c \
	src/gl/framebuffers.c \
	src/gl/gl_lookup.c \
	src/gl/getter.c \
	src/gl/gl4es.c \
	src/gl/glstate.c \
	src/gl/hint.c \
    src/gl/host.c \
	src/gl/init.c \
	src/gl/light.c \
	src/gl/line.c \
	src/gl/list.c \
	src/gl/listdraw.c \
	src/gl/listrl.c \
	src/gl/loader.c \
	src/gl/logs.c \
	src/gl/matrix.c \
	src/gl/matvec.c \
	src/gl/oldprogram.c \
	src/gl/pixel.c \
	src/gl/planes.c \
	src/gl/pointsprite.c \
	src/gl/preproc.c \
	src/gl/program.c \
	src/gl/queries.c \
	src/gl/raster.c \
	src/gl/render.c \
	src/gl/samplers.c \
	src/gl/shader.c \
	src/gl/shaderconv.c \
	src/gl/shader_hacks.c \
	src/gl/stack.c \
	src/gl/stencil.c \
	src/gl/string_utils.c \
	src/gl/stubs.c \
	src/gl/texenv.c \
	src/gl/texgen.c \
	src/gl/texture.c \
	src/gl/texture_compressed.c \
	src/gl/texture_params.c \
	src/gl/texture_read.c \
	src/gl/texture_3d.c \
	src/gl/uniform.c \
	src/gl/vertexattrib.c \
	src/gl/wrap/gl4eswraps.c \
	src/gl/wrap/gles.c \
	src/gl/wrap/glstub.c \
	src/gl/math/matheval.c \
	src/glx/hardext.c \
	src/glx/glx.c \
	src/glx/lookup.c \
	src/glx/gbm.c \
	src/glx/streaming.c \
	src/egl/egl.c \
	src/egl/lookup.c \
	src/gl/vgpu/shaderconv.c \
	src/gl/vgpu/state.c \
    src/gl/vgpu/buffer_copier.c \
    src/gl/iProtecc/iprotecc_string.c \




LOCAL_CPP_FEATURES := exceptions

LOCAL_CPPFLAGS = -std=gnu++20 -DGLSLANG_OSINCLUDE_UNIX -DENABLE_OPT=0 -DANDROID -DHAVE_STRUCT_TIMESPEC -DDETECT_OS_ANDROID

LOCAL_CFLAGS += -g -funwind-tables -fvisibility=hidden -include include/android_debug.h
#LOCAL_CFLAGS += -DDEBUG
#LOCAL_CFLAGS += -Ofast -ffast-math -mllvm -polly -flto
LOCAL_CFLAGS += -DNOX11
LOCAL_CFLAGS += -DNO_GBM
#LOCAL_CFLAGS += -DNO_INIT_CONSTRUCTOR
LOCAL_CFLAGS += -DDEFAULT_ES=2

LOCAL_CFLAGS += -std=gnu2x
LOCAL_CFLAGS += -D_LIB
LOCAL_CFLAGS += -DNOMINMAX
LOCAL_CFLAGS += -D_USE_MATH_DEFINES
LOCAL_CFLAGS += -D__STDC_NO_THREADS__
LOCAL_CFLAGS += -D__STDC_LIMIT_MACROS
LOCAL_CFLAGS += -D__STDC_FORMAT_MACROS
LOCAL_CFLAGS += -D__STDC_CONSTANT_MACROS
LOCAL_CFLAGS += -DUTIL_ARCH_LITTLE_ENDIAN
LOCAL_CFLAGS += -DUNIX
LOCAL_CFLAGS += -DANDROID -DHAVE_STRUCT_TIMESPEC -DDETECT_OS_ANDROID
LOCAL_CFLAGS += -DHAVE_OPENGL
LOCAL_CFLAGS += -DHAVE_OPENGL_ES_1
LOCAL_CFLAGS += -DHAVE_OPENGL_ES_2

//TODO: maybe temporary?
LOCAL_CFLAGS += -Wno-typedef-redefinition -Wno-dangling-else

# size: let the linker drop whatever glslang / SPIRV-Cross code is unused
LOCAL_CFLAGS += -ffunction-sections -fdata-sections
LOCAL_LDFLAGS += -Wl,--gc-sections
LOCAL_LDLIBS := -llog
#building as a static lib

include $(BUILD_SHARED_LIBRARY)
