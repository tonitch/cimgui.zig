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
    });

    const imgui = b.addLibrary(.{
        .name = "imgui", 
        .root_module = imgui_mod,
    });
    imgui.linkLibCpp();
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

    // ----
    
    const cimgui_dep = b.dependency("cimgui", .{
        .target = target,
        .optimize = optimize,
    });

    const lib_mod = b.addModule("cimgui", .{
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .name = "cimgui",
        .root_module = lib_mod,
    });

    lib.addIncludePath(cimgui_dep.path(""));
    lib.addIncludePath(imgui_dep.path(".."));
    lib.addCSourceFile(.{
        .file = cimgui_dep.path("cimgui.cpp"),
    });

    b.installArtifact(imgui);
    b.installArtifact(lib);
}
