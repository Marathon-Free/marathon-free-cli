class_name Game extends Node

#@export var default_level

var c_level: Level

func load_level(level: Level) -> void:
	$Gameplay.add_child(level)

func _ready() -> void:
	load_level(preload("res://levels/dev_level.tscn").instantiate() as Level)
