extends Node

var pausable := true
var sens_multi := 1.0
var mouse_sensitivity := 9.0
var controller_sensitivity := 3.0
var default_fov := 90.0

var vsync:int:
	set(v):
		vsync = v
		DisplayServer.window_set_vsync_mode(v)


signal open_level(level: Level)

func load_level(level_scene: PackedScene) -> void:
	var level := level_scene.instantiate() as Level
	assert(level is Level, "Node \"" + level.name + "\" is not a level.")
	open_level.emit(level)

func _ready() -> void:
	vsync = DisplayServer.VSYNC_DISABLED
