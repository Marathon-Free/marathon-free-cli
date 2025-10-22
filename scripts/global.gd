extends Node

var pausable := true
var sens_multi := 1.0
var mouse_sensitivity := 9.0
var controller_sensitivity := 3.0
var default_fov := 90.0

signal open_level(level: Level)

func load_level(level_scene: PackedScene) -> void:
	var level := level_scene.instantiate() as Level
	assert(level is Level, "Node \"" + level.name + "\" is not a level.")
	open_level.emit(level)

func _ready() -> void:
	# Replace with loading from config file
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
