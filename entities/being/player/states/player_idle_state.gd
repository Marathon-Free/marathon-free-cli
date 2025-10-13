class_name PlayerIdleState extends PlayerMovementState

func phys_update(delta: float) -> void:
	move(delta)
	PLAYER.move_and_slide()
	if !PLAYER.is_on_floor():
		transition.emit("PlayerAirState")
		return
	if Input.get_vector("player_move_left", "player_move_right", "player_move_fowards", "player_move_backwards"):
		transition.emit("PlayerWalkingState")
		return
