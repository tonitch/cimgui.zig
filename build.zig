const std = @import("std");

pub const Backend = struct {
    glfw: bool = false,
    wgpu: bool = false,
    opengl3: bool = false,
    vulkan: bool = false,
    dx12: bool = false,
    win32: bool = false,
    sdl2: bool = false,
    osx_metal: bool = false,
    sdlrenderer2: bool = false,
    sdl3: bool = false,
    sdlrenderer3: bool = false,
    sdlgpu3: bool = false,
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    var backend: Backend = .{};
    inline for (std.meta.fields(Backend)) |field|{
        const curr = b.option(field.type, field.name, "backend to add to cimgui") orelse false;
        @field(backend, field.name) = curr;
    }

    const imgui_dep = b.dependency("imgui", .{
        .target = target,
        .optimize = optimize,
    });

    const imgui_mod =  b.addModule("imgui", .{
        .target = target,
        .optimize = optimize,
        .link_libcpp = true,
    });

    const imgui = b.addLibrary(.{
        .name = "imgui",
        .root_module = imgui_mod,
    });

    imgui.addCSourceFiles(.{
        .root = imgui_dep.path(""),
        .files = &.{
            "imgui.cpp",
            "imgui_widgets.cpp",
            "imgui_tables.cpp",
            "imgui_draw.cpp",
            "imgui_demo.cpp",
        },
    });
    imgui.installHeadersDirectory(imgui_dep.path(""), "imgui", .{});



    imgui.addIncludePath(imgui_dep.path("")); //For backend

    inline for (std.meta.fields(@TypeOf(backend))) |field|{
        if(@field(backend, field.name)){
            imgui.addCSourceFiles(.{
                .root = imgui_dep.path(""),
                .files = &.{
                    b.fmt("backends/imgui_impl_{s}.cpp", .{field.name}),
                },
            });
        }
    }

    b.installArtifact(imgui);

    const cimgui_dep = b.dependency("cimgui", .{
        .target = target,
        .optimize = optimize,
    });

    const cimgui_mod = b.addModule("cimgui", .{
        .target = target,
        .optimize = optimize,
        .link_libcpp = true,
    });

    const cimgui = b.addLibrary(.{
        .name = "cimgui",
        .root_module = cimgui_mod,
    });

    cimgui.linkLibrary(imgui);
    cimgui.addCSourceFile(.{
        .file = cimgui_dep.path("cimgui.cpp"),
    });
    cimgui.installHeadersDirectory(cimgui_dep.path(""), "", .{});

    b.installArtifact(cimgui);

}
