#@tool
class_name PlayerBody3D extends CharacterBody3D

@export var BEING_STATUS: BeingStatus
@export var COLLISION_SHAPE: CollisionShape3D
@export var CROUCH_CAST: ShapeCast3D
@export var PIVOT_Y: Node3D
@export var PIVOT_X: Node3D
@export var CAMERA: Camera3D
@export var RAY_CAST: RayCast3D
@export var VIEW_MODEL: ViewModel
@export var MOVEMENT_STATE_MACHINE: StateMachine
@export var MOVEMENT_PLAYER: AnimationPlayer
@export var STANCE_STATE_MACHINE: StateMachine
@export var STANCE_PLAYER: AnimationPlayer

var speed := 0.0
var acceleration := 0.0
var friction := 0.0
var jump_strength := 0.0

var speed_multi := 1.0
var speed_multi_zeroes := 0 # We add multipliers by multiplying the previous value, and remove them
							# by dividing. As a result, we have to keep track of x0 multipliers 
							# seperately.
var accel_multi := 1.0
var accel_multi_zeroes := 0
var frict_multi := 1.0
var frict_multi_zeroes := 0
var j_vel_multi := 1.0
var j_vel_multi_zeroes := 0

var is_zoomed := false

func _ready() -> void:
	#print("Ready")
	return

func _physics_process(delta: float) -> void:
	var facing : Vector3
	if RAY_CAST.is_colliding():
		facing = RAY_CAST.get_collision_point()
	else:
		facing = RAY_CAST.target_position.length() * (-CAMERA.global_transform.basis.z) + CAMERA.global_position
	
	# Controller Look
	var look_dir := -Input.get_vector(&"player_look_left", &"player_look_right", &"player_look_up", &"player_look_down")
	if look_dir: look(look_dir * delta, true)
	
	VIEW_MODEL.collider = RAY_CAST.get_collider()
	#VIEW_MODEL.facing_point = facing
	VIEW_MODEL.point_held_item(delta, facing, up_direction)
	#print(facing)
	
	CAMERA.fov = VIEW_MODEL.zoom(delta, CAMERA.fov)
	
	move(delta)
	move_and_slide()
	
	return

func damaged() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Mouse Look
		# event.relative gives ridiculously high values.
		look(-event.relative/10000)

func look(look_vec: Vector2, is_controller := false) -> void:
	var sensitivity := Global.controller_sensitivity if is_controller else Global.mouse_sensitivity
	PIVOT_X.rotate_x(look_vec.y * sensitivity * Global.sens_multi)
	PIVOT_X.rotation.x = clampf(PIVOT_X.rotation.x, -PI/2, PI/2)
	PIVOT_Y.rotate_y(look_vec.x * sensitivity * Global.sens_multi)

func move(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed(&"player_jump") && j_vel_multi_zeroes == 0:
		velocity += jump_strength * j_vel_multi * global_transform.basis.y
	
	# This movement direction works, even if the player is rotated (Like to match the gravity)
	var lraxis := Input.get_axis(&"player_move_left", &"player_move_right")
	var fbaxis := Input.get_axis(&"player_move_fowards", &"player_move_backwards")
	var direction := (PIVOT_Y.global_transform.basis.x * lraxis + PIVOT_Y.global_transform.basis.z * fbaxis)
	if direction.length() > 1: direction = direction.normalized()
	if speed_multi_zeroes > 0: direction = Vector3.ZERO
	
	
	var accel2 := acceleration * accel_multi if accel_multi_zeroes == 0 else 0.0
	var frict2 := friction * frict_multi if frict_multi_zeroes == 0 else 0.0
	
	var velaccel = velocity.lerp(direction * speed * speed_multi, accel2 * speed_multi * delta)
	var velfric = velocity.lerp(direction * speed * speed_multi, frict2 * delta)
	
	velocity = velaccel if velaccel.length() < velfric.length() else velfric
	if velocity.length() >= 0.1 or direction: return
	velocity = Vector3.ZERO

func apply_speed_multiplier(new_multi: float) -> void:
	if new_multi == 0.0 and speed_multi_zeroes > 0: speed_multi_zeroes += 1
	else: speed_multi *= new_multi
func remove_speed_multiplier(end_multi: float) -> void:
	if end_multi == 0.0 and speed_multi_zeroes > 0: speed_multi_zeroes -= 1
	else: speed_multi /= end_multi
func apply_accel_multiplier(new_multi: float) -> void:
	if new_multi == 0.0 and accel_multi_zeroes > 0: accel_multi_zeroes += 1
	else: accel_multi *= new_multi
func remove_accel_multiplier(end_multi: float) -> void:
	if end_multi == 0.0 and accel_multi_zeroes > 0: accel_multi_zeroes -= 1
	else: accel_multi /= end_multi
func apply_frict_multiplier(new_multi: float) -> void:
	if new_multi == 0.0 and frict_multi_zeroes > 0: frict_multi_zeroes += 1
	else: frict_multi *= new_multi
func remove_frict_multiplier(end_multi: float) -> void:
	if end_multi == 0.0 and frict_multi_zeroes > 0: frict_multi_zeroes -= 1
	else: frict_multi /= end_multi
func apply_jump_multiplier(new_multi: float) -> void:
	if new_multi == 0.0 and j_vel_multi_zeroes > 0: j_vel_multi_zeroes += 1
	else: j_vel_multi *= new_multi
func remove_jump_multiplier(end_multi: float) -> void:
	if end_multi == 0.0 and j_vel_multi_zeroes > 0: j_vel_multi_zeroes -= 1
	else: j_vel_multi /= end_multi





func _on_movement_state_machine_new_state(state: State, _stop_state: State) -> void:
	assert(state is PlayerMovementState)
	var m_state := state as PlayerMovementState
	
	speed = m_state.SPEED
	acceleration = m_state.ACCELERATION
	friction = m_state.FRICTION
	jump_strength = m_state.JUMP_STRENGTH


func _on_stance_state_machine_new_state(state: State, stop_state: State) -> void:
	assert(state is PlayerStanceState)
	var s_state := state as PlayerStanceState
	apply_speed_multiplier(s_state.SPEED_MULTIPLIER)
	apply_accel_multiplier(s_state.ACCEL_MULTIPLIER)
	apply_frict_multiplier(s_state.FRICT_MULTIPLIER)
	if stop_state is not PlayerStanceState: return
	remove_speed_multiplier(stop_state.SPEED_MULTIPLIER)
	remove_accel_multiplier(s_state.ACCEL_MULTIPLIER)
	remove_frict_multiplier(s_state.FRICT_MULTIPLIER)
