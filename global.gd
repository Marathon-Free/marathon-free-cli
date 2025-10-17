extends Node

signal load_level(level: Level)

#func load_level(level: Level) -> void:
	#$Gameplay.add_child(level)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await 
	#load_level.emit()
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
