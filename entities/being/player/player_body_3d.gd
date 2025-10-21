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
	pass
	#print("Ready")

func _physics_process(delta: float) -> void:
	var facing : Vector3
	if RAY_CAST.is_colliding():
		facing = RAY_CAST.get_collision_point()
	else:
		facing = -1000 * CAMERA.global_transform.basis.z
	
	VIEW_MODEL.point_held_item(facing, delta)
	#print(facing)
	
	
	
	zoom(delta)
	
	return

func zoom(delta: float) -> void:
	# set zoom status
	if Input.is_action_just_pressed(&"zoom_hold"):   is_zoomed = true
	if Input.is_action_just_released(&"zoom_hold"):  is_zoomed = false
	if Input.is_action_just_pressed(&"zoom_toggle"): is_zoomed = !is_zoomed
	
	Global.sens_multi = 0.5 if is_zoomed else 1.0
	
	var z_speed := 8.0				# Zoom Speed
	var d_fov := Global.default_fov	# Default FOV
	var c_fov := CAMERA.fov			# Current Camera FOV
	var t_fov : float				# FOV to switch to
	
	if is_zoomed: t_fov = lerpf(c_fov, d_fov / 2, delta * z_speed)
	else: t_fov = lerpf(c_fov, d_fov, delta * z_speed)
	if c_fov == t_fov: return
	CAMERA.fov = t_fov
