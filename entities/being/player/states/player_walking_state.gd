class_name PlayerWalkingState extends PlayerMovementState

func phys_update(delta: float) -> void:
	#print("walking")
	move(delta)
	PLAYER.move_and_slide()
	if not PLAYER.is_on_floor():
		transition.emit("PlayerAirState")
	if PLAYER.velocity.length() == 0:
		transition.emit("PlayerIdleState")
