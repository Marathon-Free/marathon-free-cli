class_name PlayerCrouchedState extends PlayerStanceState

var trying_to_crouch: bool
@export var animation_speed := 3.0

func enter() -> void:
	trying_to_crouch = true
	
	if ANIM_PLAYER.is_playing(): await ANIM_PLAYER.animation_finished
	ANIM_PLAYER.play("crouch", -1, animation_speed)

func exit() -> void:
	if ANIM_PLAYER.is_playing(): await ANIM_PLAYER.animation_finished
	ANIM_PLAYER.play("crouch", -1, -animation_speed, true)

func phys_update(_delta: float) -> void:
	if Input.is_action_just_pressed(&"crouch_hold"): trying_to_crouch = true
	if Input.is_action_just_released(&"crouch_hold"): trying_to_crouch = false
	if Input.is_action_just_pressed(&"crouch_toggle"): trying_to_crouch = !trying_to_crouch
	
	# Test whether the crouch logic is working.
	#print(trying_to_crouch, " // ",  CROUCH_CAST.is_colliding())
	
	if !(trying_to_crouch or PLAYER.CROUCH_CAST.is_colliding()):
		transition.emit(&"PlayerStandingState")
