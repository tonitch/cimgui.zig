const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const imgui_dep = b.dependency("imgui", .{
        .target = target,
        .optimize = optimize,
    });

    const imgui_mod = b.addModule("imgui", .{
        .target = target,
        .optimize = optimize,
        .link_libcpp = true,
    });

    const imgui = b.addLibrary(.{
        .name = "imgui", 
        .root_module = imgui_mod,
    });

    imgui.addIncludePath(imgui_dep.path(""));
    imgui.addCSourceFiles(.{
        .root = imgui_dep.path(""),
        .files = &.{
            "imgui.cpp",
            "imgui_demo.cpp",
            "imgui_draw.cpp",
            "imgui_tables.cpp",
            "imgui_widgets.cpp",
        }
    });

    b.installArtifact(imgui);

    // ---- cimgui ----
    
    const cimgui_dep = b.dependency("cimgui", .{
        .target = target,
        .optimize = optimize,
    });

    const lib_mod = b.addModule("cimgui", .{
        .target = target,
        .optimize = optimize,
        .link_libcpp = true,
    });

    const lib = b.addLibrary(.{
        .name = "cimgui",
        .root_module = lib_mod,
    });

    const wf = b.addWriteFiles();
    _ = wf.addCopyFile(imgui_dep.path("imgui.h"), "imgui/imgui.h");
    _ = wf.addCopyFile(imgui_dep.path("imconfig.h"), "imgui/imconfig.h");
    _ = wf.addCopyFile(imgui_dep.path("imgui_internal.h"), "imgui/imgui_internal.h");
    _ = wf.addCopyFile(imgui_dep.path("imstb_rectpack.h"), "imgui/imstb_rectpack.h");
    _ = wf.addCopyFile(imgui_dep.path("imstb_textedit.h"), "imgui/imstb_textedit.h");
    _ = wf.addCopyFile(imgui_dep.path("imstb_truetype.h"), "imgui/imstb_truetype.h");

    lib.addIncludePath(wf.getDirectory());
    lib.addIncludePath(cimgui_dep.path(""));
    lib.addCSourceFile(.{
        .file = cimgui_dep.path("cimgui.cpp"),
    });

    lib.installHeader(cimgui_dep.path("cimgui.h"), "cimgui.h");

    b.installArtifact(lib);
}
