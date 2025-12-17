class_name PlayerBody3D extends CharacterBody3D

@onready var COLLISION_SHAPE := $CollisionShape3D as CollisionShape3D
@onready var CROUCH_CAST := $CrouchCast as ShapeCast3D
@onready var CROUCH_CAST2 := $CrouchCast2 as ShapeCast3D
@onready var PIVOT_Y := $PivotY as Node3D
@onready var PIVOT_X := $PivotY/PivotX as Node3D
@onready var CAMERA := $PivotY/PivotX/Camera3D as Camera3D
@onready var RAY_CAST := $PivotY/PivotX/Camera3D/RayCast3D as RayCast3D
@onready var VIEW_MODEL := $PivotY/PivotX/Camera3D/ViewModel as ViewModel
@onready var MOVEMENT_PLAYER := $MovementPlayer as AnimationPlayer
@onready var STANCE_PLAYER := $StancePlayer as AnimationPlayer

var speed := 0.0
var acceleration := 0.0
var friction := 0.0
var jump_strength := 0.0

var speed_multi := 1.0
var speed_multi_zeroes := 0
var jump_vel_multi := 1.0
var jump_vel_multi_zeroes := 0

var is_zoomed := false

func _ready() -> void:
	VIEW_MODEL.camera = CAMERA
	#print("Ready")
	return

func _physics_process(delta: float) -> void:
	var facing : Vector3
	if RAY_CAST.is_colliding():
		facing = RAY_CAST.get_collision_point()
	else:
		facing = -RAY_CAST.target_position.length() * CAMERA.global_transform.basis.z + CAMERA.global_position
	
	VIEW_MODEL.collider = RAY_CAST.get_collider()
	VIEW_MODEL.facing_point = facing
	VIEW_MODEL.point_held_item(delta)
	#print(facing)
	
	# Controller Look
	var look_dir := -Input.get_vector(&"player_look_left", &"player_look_right", &"player_look_up", &"player_look_down")
	if look_dir: look(look_dir * delta, true)
	
	move(delta)
	move_and_slide()
	#zoom(delta)
	
	return

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Mouse Look
		look(-event.relative/10000)

func look(mouse_movement: Vector2, is_controller := false) -> void:
	if is_controller:
		PIVOT_X.rotate_x(mouse_movement.y * Global.controller_sensitivity * Global.sens_multi)
		PIVOT_X.rotation.x = clampf(PIVOT_X.rotation.x, -1.5708, 1.5708)
		PIVOT_Y.rotate_y(mouse_movement.x * Global.controller_sensitivity * Global.sens_multi)
		return
	PIVOT_X.rotate_x(mouse_movement.y * Global.mouse_sensitivity * Global.sens_multi)
	PIVOT_X.rotation.x = clampf(PIVOT_X.rotation.x, -1.5708, 1.5708)
	PIVOT_Y.rotate_y(mouse_movement.x * Global.mouse_sensitivity * Global.sens_multi)

func move(delta := 1.0) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed(&"player_jump") && jump_vel_multi_zeroes == 0:
		velocity += jump_strength * jump_vel_multi * global_transform.basis.y
	
	# This movement direction works, even if the player is rotated (Like to match the gravity)
	var lraxis := Input.get_axis(&"player_move_left", &"player_move_right")
	var fbaxis := Input.get_axis(&"player_move_fowards", &"player_move_backwards")
	var direction := (PIVOT_X.global_transform.basis.x * lraxis + PIVOT_Y.global_transform.basis.z * fbaxis)
	if direction.length() > 1: direction = direction.normalized()
	if speed_multi_zeroes > 0: direction = Vector3.ZERO
	
	var velaccel = velocity.lerp(direction * speed * speed_multi, acceleration * speed_multi * delta)
	var velfric = velocity.lerp(direction * speed * speed_multi, friction * delta)
	
	velocity = velaccel if velaccel.length() < velfric.length() else velfric
	if velocity.length() >= 0.1 or direction: return
	velocity = Vector3.ZERO

func apply_speed_multiplier(new_multi: float) -> void:
	if new_multi == 0.0 and speed_multi_zeroes > 0: speed_multi_zeroes += 1
	else: speed_multi *= new_multi

func remove_speed_multiplier(end_multi: float) -> void:
	if end_multi == 0.0 and speed_multi_zeroes > 0: speed_multi_zeroes -= 1
	else: speed_multi /= end_multi

func apply_jump_multiplier(new_multi: float) -> void:
	if new_multi == 0.0 and jump_vel_multi_zeroes > 0: jump_vel_multi_zeroes += 1
	else: jump_vel_multi *= new_multi

func remove_jump_multiplier(end_multi: float) -> void:
	if end_multi == 0.0 and jump_vel_multi_zeroes > 0: jump_vel_multi_zeroes -= 1
	else: jump_vel_multi /= end_multi

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
	if stop_state is not PlayerStanceState: return
	remove_speed_multiplier(stop_state.SPEED_MULTIPLIER)
