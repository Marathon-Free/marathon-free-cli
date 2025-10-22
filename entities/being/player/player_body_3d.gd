class_name PlayerBody3D extends CharacterBody3D

@onready var MOVEMENT_PLAYER := $MovementPlayer as AnimationPlayer
@onready var STANCE_PLAYER := $StancePlayer as AnimationPlayer
@onready var PIVOT_Y := $PivotY as Node3D
@onready var PIVOT_X := $PivotY/PivotX as Node3D
@onready var CAMERA := $PivotY/PivotX/Camera3D as Camera3D
@onready var RAY_CAST := $PivotY/PivotX/Camera3D/RayCast3D as RayCast3D
@onready var VIEW_MODEL := $PivotY/PivotX/Camera3D/ViewModel as ViewModel

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var is_zoomed := false

# Player controls, and much more, are in the state machine.

func _ready() -> void:
	VIEW_MODEL.camera = CAMERA
	#print("Ready")
	return

func _physics_process(delta: float) -> void:
	var facing : Vector3
	if RAY_CAST.is_colliding():
		facing = RAY_CAST.get_collision_point()
	else:
		facing = -1000 * CAMERA.global_transform.basis.z
	
	VIEW_MODEL.facing_point = facing
	VIEW_MODEL.point_held_item(delta)
	#print(facing)
	
	
	
	#zoom(delta)
	
	return
