@tool

class_name ViewModel extends Node3D

@export var MOVEMENT_PIVOT: Node3D
@export var HAND_PIVOT: Node3D
@export var RECOIL_PIVOT: Node3D
@export var MESH_INSTANCE: MeshInstance3D
@export var camera: Camera3D
@export var held_item:HeldItem:
	set(v):
		held_item = v
		if Engine.is_editor_hint(): load_held_item()

var is_zoomed := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_held_item()

func _physics_process(delta: float) -> void:
	zoom(delta)

func zoom(delta: float) -> void:
	# set zoom status
	if Input.is_action_just_pressed(&"zoom_hold"):   is_zoomed = true
	if Input.is_action_just_released(&"zoom_hold"):  is_zoomed = false
	if Input.is_action_just_pressed(&"zoom_toggle"): is_zoomed = !is_zoomed
	
	if !camera: return
	
	Global.sens_multi = 0.5 if is_zoomed else 1.0
	
	var z_speed := 8.0              # Zoom Speed
	var d_fov := Global.default_fov # Default FOV
	var c_fov := camera.fov         # Current Camera FOV
	var t_fov : float               # FOV to switch to
	
	if is_zoomed: t_fov = lerpf(c_fov, d_fov / 2, delta * z_speed)
	else: t_fov = lerpf(c_fov, d_fov, delta * z_speed)
	if c_fov == t_fov: return
	camera.fov = t_fov

func load_held_item() -> void:
	HAND_PIVOT.position = held_item.offset
	MESH_INSTANCE.rotation = held_item.rotation
	MESH_INSTANCE.scale = held_item.scale
	MESH_INSTANCE.mesh = held_item.mesh

func point_held_item(global_point: Vector3, delta: float) -> void:
	var currently_facing := -HAND_PIVOT.global_transform.basis.z
	var vector_to := global_point - HAND_PIVOT.global_position
	
	var axis := currently_facing.cross(vector_to).normalized()
	var angle := currently_facing.angle_to(vector_to)
	
	HAND_PIVOT.global_rotate(axis, lerpf(0.0, angle, 2*delta))
	HAND_PIVOT.rotation.z = 0
	#print(MOVEMENT_PIVOT.global_rotation)
