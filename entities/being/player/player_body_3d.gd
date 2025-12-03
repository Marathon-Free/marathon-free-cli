class_name PlayerBody3D extends CharacterBody3D

@onready var MOVEMENT_PLAYER := $MovementPlayer as AnimationPlayer
@onready var STANCE_PLAYER := $StancePlayer as AnimationPlayer
@onready var PIVOT_Y := $PivotY as Node3D
@onready var PIVOT_X := $PivotY/PivotX as Node3D
@onready var CAMERA := $PivotY/PivotX/Camera3D as Camera3D
@onready var RAY_CAST := $PivotY/PivotX/Camera3D/RayCast3D as RayCast3D
@onready var VIEW_MODEL := $PivotY/PivotX/Camera3D/ViewModel as ViewModel

var speed := 0.0
var acceleration := 0.0
var friction := 0.0
var jump_strength := 0.0

var speed_multi := 1.0

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
		facing = -1000 * CAMERA.global_transform.basis.z
	
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
	var velocity_2 := velocity
	
	if not is_on_floor():
		velocity_2 += get_gravity() * delta
	
	if Input.is_action_just_pressed(&"player_jump"):
		velocity_2 += jump_strength * global_transform.basis.y
	
	# This movement direction works, even if the player is rotated (Like to match the gravity)
	var lraxis := Input.get_axis(&"player_move_left", &"player_move_right")
	var fbaxis := Input.get_axis(&"player_move_fowards", &"player_move_backwards")
	var direction := (PIVOT_X.global_transform.basis.x * lraxis + PIVOT_Y.global_transform.basis.z * fbaxis)
	if direction.length() > 1: direction = direction.normalized()
	
	var velaccel = velocity_2.lerp(direction * speed * speed_multi, acceleration * speed_multi * delta)
	var velfric = velocity_2.lerp(direction * speed * speed_multi, friction * delta)
	
	velocity_2 = velaccel if velaccel.length() < velfric.length() else velfric
	if velocity_2.length() < 0.1 and !direction:
		velocity_2 = Vector3.ZERO
	
	velocity = velocity_2


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
	if stop_state is PlayerStanceState:
		speed_multi /= stop_state.SPEED_MULTIPLIER
	speed_multi *= s_state.SPEED_MULTIPLIER
