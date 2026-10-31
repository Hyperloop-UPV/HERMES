#define VL_BUILD_IMPLEMENTATION
#include "include/vl_build.h"

#if OS_WINDOWS
#define CCompiler CCompiler_MSVC
#else
#define CCompiler CCompiler_GPlusPlus
#endif

/* File containing build script for simple visual micro simulator
 *
 * Created on: 27 oct. 2026
 *   Author: victor
 */

/*
in libs, only an sdl static library is expected
*/
bool build_imgui(vl_file_paths *libs)
{
  vl_cmd cmd = {0};
  if(VL_NeedsRebuild("bin/imgui" VL_OBJ_EXT, "vendor/imgui/imgui.cpp")) {
#if OS_WINDOWS
    CmdAppend(&cmd, "cl", "-c", "vendor/imgui/*.cpp", "-Zi", "-I", "include", "/link", "/libpath:lib", "SDL3.lib", "-incremental:no", "-opt:ref");
    if(!CmdRun(&cmd)) {
      VL_Log(VL_ERROR, "Could not build dear imgui libs");
      return false;
    }

#else

    vl_compile_ctx ctx = {
      .cc = CCompiler_GPlusPlus,
      .type = Compile_Object,
      .debug = true,
      .gcSections = true,
      .warnings = false,
      .sourceFiles = VL_GetDaStrSlice("vendor/imgui/*"),

      .includePaths = VL_GetDaStrSlice("include"),
      .libPaths = VL_GetDaStrSlice("lib"),
      .libs = *libs,
    };

    if(!VL_CCompile(&cmd, &ctx)) {
      VL_Log(VL_ERROR, "Could not build dear imgui libs");
      return false;
    }
#endif

    VL_MoveFile("imgui_draw" VL_OBJ_EXT,      "bin/imgui_draw" VL_OBJ_EXT);
    VL_MoveFile("imgui_impl_sdl3" VL_OBJ_EXT, "bin/imgui_impl_sdl3" VL_OBJ_EXT);
    VL_MoveFile("imgui_impl_sdlrenderer3" VL_OBJ_EXT, "bin/imgui_impl_sdlrenderer3" VL_OBJ_EXT);
    VL_MoveFile("imgui_tables" VL_OBJ_EXT,    "bin/imgui_tables" VL_OBJ_EXT);
    VL_MoveFile("imgui_widgets" VL_OBJ_EXT,   "bin/imgui_widgets" VL_OBJ_EXT);
    VL_MoveFile("imgui" VL_OBJ_EXT,           "bin/imgui" VL_OBJ_EXT);
    VL_MoveFile("implot_items" VL_OBJ_EXT,    "bin/implot_items" VL_OBJ_EXT);
    VL_MoveFile("implot" VL_OBJ_EXT,          "bin/implot" VL_OBJ_EXT);
  }

  return true;
}

int main(int argc, char **argv)
{
  //VL_GO_REBUILD_URSELF(argc, argv);

  MkdirIfNotExist("dynamic_libs");
  MkdirIfNotExist("bin");

  vl_cmd cmd = {0};
  vl_install_info info = {
#if OS_WINDOWS
   .cc = CCompiler_MSVC,
#endif
    .mode = VL_INSTALL_MODE_RELEASE,
  };
  if(!Install_SDL3(&cmd, &info)) {
    VL_Log(VL_ERROR, "Could not install SDL3");
    return 1;
  }

  if(!build_imgui(&info.libs)) {
    return 1;
  }

  vl_compile_ctx ctx = {
    .cc = CCompiler,
    .type = Compile_DynamicLibrary,
    .debug = true,
    .gcSections = true,
    .warnings = true,

    .sourceFiles = VL_GetDaStrSlice(
      "src/main.cpp",
      "bin/*" VL_OBJ_EXT
    ),
    .output = "usim-vis",
    .outputDir = "bin",

    .includePaths = VL_GetDaStrSlice("include"),
    .libs = info.libs,
    .libPaths = VL_GetDaStrSlice("lib"),
  };

  if(!VL_CCompile(&cmd, &ctx)) {
    VL_Log(VL_ERROR, "Could not compile main.cpp");
    return 1;
  }

  return 0;
}
