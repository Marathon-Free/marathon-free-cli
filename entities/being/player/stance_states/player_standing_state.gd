class_name PlayerStandingState extends PlayerStanceState

func enter() -> void:
	#ANIM_PLAYER.play("RESET")
	return

func phys_update(_delta: float) -> void:
	if Input.is_action_just_pressed("crouch_hold") or Input.is_action_just_pressed("crouch_toggle"):
		transition.emit("PlayerCrouchedState")
