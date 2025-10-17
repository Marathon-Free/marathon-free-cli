extends Node

var pausable := true

signal open_level(level: Level)

func load_level(level_scene: PackedScene) -> void:
	var level := level_scene.instantiate() as Level
	assert(level is Level, "Node \"" + level.name + "\" is not a level.")
	open_level.emit(level)
