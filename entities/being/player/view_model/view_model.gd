@tool

class_name ViewModel
extends Node3D

@export var MOVEMENT_PIVOT: Node3D
@export var ARM_PIVOT: Node3D
@export var ARM_PIVOT2: Node3D
@export var HAND_PIVOT: Node3D
@export var RECOIL_PIVOT: Node3D
@export var MESH_INSTANCE: MeshInstance3D
@export var PROJECTILE_START_POINT: Node3D
@export var ANIM_PLAYER: AnimationPlayer 
@export var REFIRE_TIMER: Timer
@export var held_item:HeldItem:
	set(v):
		held_item = v
		if Engine.is_editor_hint(): load_held_item()

#var facing_point: Vector3
var collider: Object
var prev_hand_rot: Vector3
var is_zoomed := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint(): 
		pass
		#ARM_PIVOT.top_level = true
		#HAND_PIVOT1.top_level = true
	load_held_item()

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	#print(REFIRE_TIMER.time_left)
	if Input.is_action_pressed(&"attack") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: attack()

func attack() -> void:
	if !REFIRE_TIMER.is_stopped(): return
	
	ANIM_PLAYER.play("default_recoil", -1, 1.0 / held_item.refire_time)
	REFIRE_TIMER.start(held_item.refire_time)
	
	#var proj := (preload("res://data/held_item/projectile.tscn") as PackedScene).instantiate() as Projectile
	#PROJECTILE_START_POINT.add_child(proj)
	#proj.global_position = PROJECTILE_START_POINT.global_position
	#proj.fire(-PROJECTILE_START_POINT.global_transform.basis.z.normalized() * 30)
	
	if collider is not Node: return
	var being: BeingStatus
	for child in (collider as Node).get_children():
		if child is BeingStatus:
			being = child
			break
	if being == null: return
	
	#owner.BEING_STATUS.damage(10.0) # Test by making the player shoot themselves lol
	being.damage(10.0)

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
	HAND_PIVOT.position.x = held_item.offset.x
	HAND_PIVOT.position.z = held_item.offset.z
	
	MESH_INSTANCE.rotation = held_item.rotation
	MESH_INSTANCE.scale = held_item.scale
	MESH_INSTANCE.mesh = held_item.mesh

func point_held_item(delta: float, facing_point: Vector3, up := Vector3.UP) -> void:
	var speed_multi := maxf(absf(ARM_PIVOT2.global_transform.basis.z.angle_to(ARM_PIVOT.global_transform.basis.z)), 1.0)
	ARM_PIVOT2.global_rotation = prev_hand_rot
	ARM_PIVOT2.global_rotation.x = lerp_angle(ARM_PIVOT2.global_rotation.x, ARM_PIVOT.global_rotation.x, 12.0 * speed_multi * delta)
	ARM_PIVOT2.global_rotation.y = lerp_angle(ARM_PIVOT2.global_rotation.y, ARM_PIVOT.global_rotation.y, 12.0 * speed_multi * delta)
	ARM_PIVOT2.global_rotation.z = lerp_angle(ARM_PIVOT2.global_rotation.z, ARM_PIVOT.global_rotation.z, 12.0 * speed_multi * delta)
	prev_hand_rot = ARM_PIVOT2.global_rotation
	
	HAND_PIVOT.look_at(facing_point, up)
	HAND_PIVOT.rotation.z = 0
