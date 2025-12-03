extends Node

var pausable := true
var sens_multi := 1.0
var mouse_sensitivity := 12.0
var controller_sensitivity := 3.0
var default_fov := 90.0

var current_level: Level

signal open_level(level: Level)

func load_level(level_scene: PackedScene) -> void:
	var inst := level_scene.instantiate()
	assert(inst is Level, "Node \"" + inst.name + "\" is not a level.")
	current_level = inst as Level
	open_level.emit(current_level)

func _ready() -> void:
	# Replace with loading from config file
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
