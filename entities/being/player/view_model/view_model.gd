@tool

class_name ViewModel extends Node3D

@export var ARM_PIVOT: Node3D
@export var MOVEMENT_PIVOT: Node3D
@export var HAND_PIVOT1: Node3D
@export var HAND_PIVOT2: Node3D
@export var RECOIL_PIVOT: Node3D
@export var MESH_INSTANCE: MeshInstance3D
@export var ANIM_PLAYER: AnimationPlayer 
@export var REFIRE_TIMER: Timer
@export var held_item:HeldItem:
	set(v):
		held_item = v
		if Engine.is_editor_hint(): load_held_item()

#var facing_point: Vector3
var collider: Object
var prev_hand_pos: Vector3
var is_zoomed := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint(): 
		#ARM_PIVOT.top_level = true
		HAND_PIVOT1.top_level = true
	load_held_item()

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	#print(REFIRE_TIMER.time_left)
	if Input.is_action_pressed(&"attack"): attack()

func attack() -> void:
	if !REFIRE_TIMER.is_stopped(): return
	
	ANIM_PLAYER.play("default_recoil", -1, 1.0 / held_item.refire_time)
	REFIRE_TIMER.start(held_item.refire_time)

func zoom(delta: float, c_fov: float) -> float:
	# set zoom status
	if Input.is_action_just_pressed(&"zoom_hold"):   is_zoomed = true
	if Input.is_action_just_released(&"zoom_hold"):  is_zoomed = false
	if Input.is_action_just_pressed(&"zoom_toggle"): is_zoomed = !is_zoomed
	
	Global.sens_multi = 1.0 if !is_zoomed else 0.5
	
	var z_speed := 8.0              # Zoom Speed
	var d_fov := Global.default_fov # Default FOV
	var t_fov : float               # FOV to switch to
	
	if is_zoomed: t_fov = lerpf(c_fov, d_fov / 2, delta * z_speed)
	else: t_fov = lerpf(c_fov, d_fov, delta * z_speed)
	return t_fov

func load_held_item() -> void:
	await ready
	ARM_PIVOT.position.y = held_item.offset.y
	HAND_PIVOT2.position.x = held_item.offset.x
	HAND_PIVOT2.position.z = held_item.offset.z
	
	MESH_INSTANCE.rotation = held_item.rotation
	MESH_INSTANCE.scale = held_item.scale
	MESH_INSTANCE.mesh = held_item.mesh

func point_held_item(delta: float, facing_point: Vector3, up := Vector3.UP) -> void:
	var speed_multi := maxf(absf(HAND_PIVOT1.global_transform.basis.z.angle_to(ARM_PIVOT.global_transform.basis.z)), 1.0)
	HAND_PIVOT1.global_position = ARM_PIVOT.global_position
	HAND_PIVOT1.global_rotation.x = lerp_angle(HAND_PIVOT1.global_rotation.x, ARM_PIVOT.global_rotation.x, 12.0 * speed_multi * delta)
	HAND_PIVOT1.global_rotation.y = lerp_angle(HAND_PIVOT1.global_rotation.y, ARM_PIVOT.global_rotation.y, 12.0 * speed_multi * delta)
	HAND_PIVOT1.global_rotation.z = lerp_angle(HAND_PIVOT1.global_rotation.z, ARM_PIVOT.global_rotation.z, 12.0 * speed_multi * delta)
	#HAND_PIVOT1.global_rotation = HAND_PIVOT1.global_rotation.lerp(ARM_PIVOT.global_rotation, 8.0 * speed_multi * delta)
	
	#prev_hand_pos = prev_hand_pos.lerp(HAND_PIVOT1.global_position, delta)
	#HAND_PIVOT2.global_position = prev_hand_pos
	
	HAND_PIVOT2.look_at(facing_point, up)
	HAND_PIVOT2.rotation.z = 0
	#var currently_facing := -HAND_PIVOT2.global_transform.basis.z
	#var vector_to := facing_point - HAND_PIVOT2.global_position
	#
	#var axis := currently_facing.cross(vector_to).normalized()
	#var angle := currently_facing.angle_to(vector_to)
	#
	#if axis: 
		##HAND_PIVOT1.global_rotate(axis, lerpf(0.0, angle, 2*delta))
		#HAND_PIVOT2.global_rotate(axis, lerpf(0.0, angle, 1))
		#HAND_PIVOT2.rotation.z = 0
	#print(MOVEMENT_PIVOT.global_rotation)
