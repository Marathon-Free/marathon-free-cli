class_name State extends Node

@warning_ignore("unused_signal")
signal transition(new_state_name: StringName)

func enter() -> void:
	pass

func exit() -> void:
	pass

@warning_ignore("unused_parameter")
func phys_update(delta: float) -> void:
	pass

@warning_ignore("unused_parameter")
func update(delta: float) -> void:
	pass

## Returns whether this state is still the current state of it's state machine.
func is_active() -> bool:
	return ($".." as StateMachine).CURRENT_STATE == self
