extends Node

var pausable := true
var sens_multi := 1.0
var mouse_sensitivity := 12.0
var controller_sensitivity := 3.0
var default_fov := 90.0
var menu_open := true

var current_level: Level

var player: PlayerBody3D

signal open_level(level: Level)

func load_level(level_scene: PackedScene) -> void:
	var inst := level_scene.instantiate()
	assert(inst is Level, "Node \"" + inst.name + "\" is not a level.")
	current_level = inst as Level
	for child in current_level.get_children():
		if child is PlayerBody3D: 
			player = child
			break
	open_level.emit(current_level)
	while player.COLLISION_SHAPE == null: pass
	player_crouch_test()

func _ready() -> void:
	# Replace with loading from config file
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func player_crouch_test() -> void:
	if player == null: return
	#print(player.COLLISION_SHAPE.position.y)
	get_tree().create_timer(0.1).timeout.connect(player_crouch_test)

func _physics_process(_delta: float) -> void:
	# Test Player crouching teleports
	
	
	
	pass
