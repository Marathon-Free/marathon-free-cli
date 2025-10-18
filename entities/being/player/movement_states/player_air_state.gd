class_name PlayerAirState extends PlayerMovementState

func phys_update(delta: float) -> void:
	#print("walking")
	move(delta)
	PLAYER.move_and_slide()
	
	if !PLAYER.is_on_floor(): return
	if Input.get_vector("player_move_left", "player_move_right", "player_move_fowards", "player_move_backwards") or PLAYER.velocity.length() > 0.0:
		transition.emit("PlayerWalkingState")
		return
	transition.emit("PlayerIdleState")
