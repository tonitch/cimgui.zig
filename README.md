# cimgui

This is [cimgui](https://github.com/cimgui/cimgui) for [Zig](ziglang.org). 

## Usage in a zig project

```
$ zig fetch --save=cimgui https://github.com/tonitch/cimgui.zig
```

then add this to your `build.zig`:

```
const cimgui_dep = b.dependency("cimgui", .{
    .target = target,
    .optimize = optimize,
});

exe.linkLibrary(cimgui_dep.artifact("cimgui"));
```
