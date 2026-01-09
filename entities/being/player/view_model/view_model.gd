@tool

class_name ViewModel
extends Node3D

@export var held_item:HeldItem:
	set(v):
		held_item = v
		if Engine.is_editor_hint(): load_held_item()
@export var movememnt_pivot: Node3D
@export var arm_pivot: Node3D
@export var arm_pivot2: Node3D
@export var hand_pivot: Node3D
@export var recoil_pivot: Node3D
@export var mesh_instance: MeshInstance3D
@export var projectile_start_point: Node3D
@export var anim_player: AnimationPlayer 
@export var refire_timer: Timer

#var facing_point: Vector3
var collider: Object
var prev_hand_rot: Vector3
var is_zoomed := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_held_item()

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	#print(refire_timer.time_left)
	if Input.is_action_pressed(&"attack") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		attack()

func attack() -> void:
	if !refire_timer.is_stopped(): return
	
	anim_player.play("default_recoil", -1, 1.0 / held_item.refire_time)
	refire_timer.start(held_item.refire_time)
	
	var p_scene := preload("res://entities/projectile/projectile.tscn") as PackedScene
	var proj := p_scene.instantiate() as Projectile

	projectile_start_point.add_child(proj)
	proj.global_position = projectile_start_point.global_position
	proj.global_rotation = projectile_start_point.global_rotation
	proj.process_mode = Node.PROCESS_MODE_INHERIT
	proj.fire(-projectile_start_point.global_basis.z.normalized() * 30, 10)
	
	#if collider is not Node: return
	#var being: BeingStatus
	#for child in (collider as Node).get_children():
		#if child is BeingStatus:
			#being = child
			#break
	#if being == null: return
	#
	owner.BEING_STATUS.damage(120.0) # Test by making the player shoot themselves lol
	#being.damage(10.0)

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
	arm_pivot.position.y = held_item.offset.y
	hand_pivot.position.x = held_item.offset.x
	hand_pivot.position.z = held_item.offset.z
	
	mesh_instance.rotation = held_item.rotation
	mesh_instance.scale = held_item.scale
	mesh_instance.mesh = held_item.mesh

func point_held_item(delta: float, facing_point: Vector3, up := Vector3.UP) -> void:
	var arm_rot1 := arm_pivot.global_rotation
	var arm_rot2 := arm_pivot2.global_rotation
	var speed_multi := maxf(absf(arm_pivot2.global_basis.z.angle_to(arm_pivot.global_basis.z)), 1.0)

	arm_pivot2.global_rotation = prev_hand_rot
	arm_pivot2.global_rotation.x = lerp_angle(arm_rot2.x, arm_rot1.x, 12.0 * speed_multi * delta)
	arm_pivot2.global_rotation.y = lerp_angle(arm_rot2.y, arm_rot1.y, 12.0 * speed_multi * delta)
	arm_pivot2.global_rotation.z = lerp_angle(arm_rot2.z, arm_rot1.z, 12.0 * speed_multi * delta)
	prev_hand_rot = arm_pivot2.global_rotation
	
	hand_pivot.look_at(facing_point, up)
	hand_pivot.rotation.z = 0
