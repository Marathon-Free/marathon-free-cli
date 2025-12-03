@tool

class_name ViewModel extends Node3D

@onready var MOVEMENT_PIVOT := $MovementPivot as Node3D
@onready var HAND_PIVOT := $MovementPivot/HandPivot as Node3D
@onready var RECOIL_PIVOT := $MovementPivot/HandPivot/RecoilPivot as Node3D
@onready var MESH_INSTANCE := $MovementPivot/HandPivot/RecoilPivot/MeshInstance3D as MeshInstance3D
@onready var ANIM_PLAYER := $AnimationPlayer as AnimationPlayer 
@onready var REFIRE_TIMER := $RefireTimer as Timer
@export var held_item:HeldItem:
	set(v):
		held_item = v
		if Engine.is_editor_hint(): load_held_item()

var camera: Camera3D
var facing_point: Vector3

var is_zoomed := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_held_item()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	zoom(delta)
	#print(REFIRE_TIMER.time_left)
	if Input.is_action_pressed(&"attack"): attack()

func attack() -> void:
	if !REFIRE_TIMER.is_stopped(): return
	
	ANIM_PLAYER.play("default_recoil", -1, 1.0 / held_item.refire_time)
	REFIRE_TIMER.start(held_item.refire_time)

func zoom(delta: float) -> void:
	# set zoom status
	if Input.is_action_just_pressed(&"zoom_hold"):   is_zoomed = true
	if Input.is_action_just_released(&"zoom_hold"):  is_zoomed = false
	if Input.is_action_just_pressed(&"zoom_toggle"): is_zoomed = !is_zoomed
	
	if !camera: return
	
	Global.sens_multi = 1.0 if !is_zoomed else 0.5
	
	var z_speed := 8.0              # Zoom Speed
	var d_fov := Global.default_fov # Default FOV
	var c_fov := camera.fov         # Current Camera FOV
	var t_fov : float               # FOV to switch to
	
	if is_zoomed: t_fov = lerpf(c_fov, d_fov / 2, delta * z_speed)
	else: t_fov = lerpf(c_fov, d_fov, delta * z_speed)
	if c_fov == t_fov: return
	camera.fov = t_fov

func load_held_item() -> void:
	await ready
	HAND_PIVOT.position = held_item.offset
	MESH_INSTANCE.rotation = held_item.rotation
	MESH_INSTANCE.scale = held_item.scale
	MESH_INSTANCE.mesh = held_item.mesh

func point_held_item(delta: float) -> void:
	var currently_facing := -HAND_PIVOT.global_transform.basis.z
	var vector_to := facing_point - HAND_PIVOT.global_position
	
	var axis := currently_facing.cross(vector_to).normalized()
	var angle := currently_facing.angle_to(vector_to)
	
	HAND_PIVOT.global_rotate(axis, lerpf(0.0, angle, 2*delta))
	HAND_PIVOT.rotation.z = 0
	#print(MOVEMENT_PIVOT.global_rotation)
