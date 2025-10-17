class_name PlayerMovementState extends State

var PLAYER: PlayerBody3D
var ANIM_PLAYER: AnimationPlayer

@export_range(0, 20, 0.2) var SPEED := 7.0
@export_range(0, 2, 0.01) var ACCELERATION := 0.7
@export_range(0, 2, 0.01) var FRICTION := 1.0
@export_range(0, 10, 0.2) var JUMP_STRENGTH := 7.0
#var SPEED := 7.0
#var ACCELERATION := 0.7
#var FRICTION := 1.0
#var JUMP_STRENGTH := 7.0

func _ready() -> void:
	# Mouse mode is controlled by game script now
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	assert(owner is PlayerBody3D)
	await owner.ready
	PLAYER = owner
	ANIM_PLAYER = PLAYER.ANIM_PLAYER

func grav_rotate() -> void:
	pass

func move(delta := 1.0) -> void:
	var velocity := PLAYER.velocity
	
	if not PLAYER.is_on_floor():
		velocity += PLAYER.get_gravity() * delta
	
	if Input.is_action_just_pressed(&"player_jump"):
		velocity += JUMP_STRENGTH * PLAYER.global_transform.basis.y
	
	var lraxis := Input.get_axis(&"player_move_left", &"player_move_right")
	var fbaxis := Input.get_axis(&"player_move_fowards", &"player_move_backwards")
	var direction := (PLAYER.PIVOT_X.global_transform.basis.x * lraxis + PLAYER.PIVOT_Y.global_transform.basis.z * fbaxis)
	if direction.length() > 1: direction = direction.normalized()
	
	var velaccel = velocity.lerp(direction * SPEED, ACCELERATION * delta)
	var velfric = velocity.lerp(direction * SPEED, FRICTION * delta)
	
	velocity = velaccel if velaccel.length() < velfric.length() else velfric
	if velocity.length() < 0.1 and !direction:
		velocity = Vector3.ZERO
	
	PLAYER.velocity = velocity

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Mouse
		look(-event.relative/10000)

func update(delta: float) -> void:
	# Controller
	var look_dir := -Input.get_vector(&"player_look_left", &"player_look_right", &"player_look_up", &"player_look_down")
	if look_dir: look(look_dir * delta, true)

func look(mouse_movement: Vector2, is_controller := false) -> void:
	if is_controller:
		PLAYER.PIVOT_X.rotate_x(mouse_movement.y * Global.controller_sensitivity)
		PLAYER.PIVOT_X.rotation.x = clampf(PLAYER.PIVOT_X.rotation.x, -1.5708, 1.5708)
		PLAYER.PIVOT_Y.rotate_y(mouse_movement.x * Global.controller_sensitivity)
		return
	PLAYER.PIVOT_X.rotate_x(mouse_movement.y * Global.mouse_sensitivity)
	PLAYER.PIVOT_X.rotation.x = clampf(PLAYER.PIVOT_X.rotation.x, -1.5708, 1.5708)
	PLAYER.PIVOT_Y.rotate_y(mouse_movement.x * Global.mouse_sensitivity)
