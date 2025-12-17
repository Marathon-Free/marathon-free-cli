class_name PlayerCrouchedState extends PlayerStanceState

var trying_to_crouch: bool

func enter() -> void:
	trying_to_crouch = true
	if !PLAYER.is_on_floor() or PLAYER.CROUCH_CAST2.is_colliding():
		ANIM_PLAYER.play(&"crouch", -1, 2.0)
		await ANIM_PLAYER.animation_finished
		return
	ANIM_PLAYER.play(&"floor_crouch", -1, 2.0)
	await ANIM_PLAYER.animation_finished
	
	PLAYER.COLLISION_SHAPE.translate_object_local(Vector3(0, 1, 0))
	PLAYER.CROUCH_CAST.translate_object_local(Vector3(0, 1, 0))
	PLAYER.PIVOT_Y.translate_object_local(Vector3(0, 1, 0))
	PLAYER.global_translate(-PLAYER.global_transform.basis.y.normalized())

func exit() -> void:
	if !PLAYER.is_on_floor() or PLAYER.CROUCH_CAST2.is_colliding():
		ANIM_PLAYER.play(&"crouch", -1, -2.0, true)
		await ANIM_PLAYER.animation_finished
		return
	PLAYER.COLLISION_SHAPE.translate_object_local(Vector3(0, -1, 0))
	PLAYER.CROUCH_CAST.translate_object_local(Vector3(0, -1, 0))
	PLAYER.PIVOT_Y.translate_object_local(Vector3(0, -1, 0))
	PLAYER.global_translate(PLAYER.global_transform.basis.y.normalized())
	ANIM_PLAYER.play(&"floor_crouch", -1, -2.0, true)
	await ANIM_PLAYER.animation_finished

func phys_update(_delta: float) -> void:
	if Input.is_action_just_pressed(&"crouch_hold"): trying_to_crouch = true
	if Input.is_action_just_released(&"crouch_hold"): trying_to_crouch = false
	if Input.is_action_just_pressed(&"crouch_toggle"): trying_to_crouch = !trying_to_crouch
	
	# Test whether the crouch logic is working.
	#print(trying_to_crouch, " // ",  CROUCH_CAST.is_colliding())
	
	if !(trying_to_crouch or PLAYER.CROUCH_CAST.is_colliding()):
		transition.emit(&"PlayerStandingState")
