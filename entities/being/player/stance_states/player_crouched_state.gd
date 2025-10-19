class_name PlayerCrouchedState extends PlayerStanceState

@export var CROUCH_CAST: ShapeCast3D

var trying_to_crouch: bool

func enter() -> void:
	trying_to_crouch = true
	ANIM_PLAYER.play("crouch", -1, 2.0)

func exit() -> void:
	ANIM_PLAYER.play("crouch", -1, -2.0, true)

func phys_update(_delta: float) -> void:
	if Input.is_action_just_pressed("crouch_hold"): trying_to_crouch = true
	if Input.is_action_just_released("crouch_hold"): trying_to_crouch = false
	if Input.is_action_just_pressed("crouch_toggle"): trying_to_crouch = !trying_to_crouch
	
	# Test whether the crouch logic is working.
	#print(trying_to_crouch, " // ",  CROUCH_CAST.is_colliding())
	
	if !(trying_to_crouch or CROUCH_CAST.is_colliding()):
		transition.emit("PlayerStandingState")
