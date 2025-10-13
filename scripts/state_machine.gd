class_name StateMachine extends Node

@export var CURRENT_STATE: State
var states: Dictionary[StringName,State] = {}

func _ready() -> void:
	# Store children in <states>
	for child in get_children():
		assert(child is State, 'State machine "' + name + '" contains an invalid child node "' + child.name + '"')
		states[child.name] = child
		child.transition.connect(on_child_transition)
	
	# Enter default state
	CURRENT_STATE.enter()

func _physics_process(delta: float) -> void:
	CURRENT_STATE.phys_update(delta)

func _process(delta: float) -> void:
	CURRENT_STATE.update(delta)

func on_child_transition(new_state_name: StringName) -> void:
	print(new_state_name)
	var new_state = states.get(new_state_name)
	
	if new_state == null: 
		push_error("State \"" + new_state_name + "\" does not exist.")
		return
	assert(new_state is State)
	if new_state == CURRENT_STATE: 
		push_error("State \"" + new_state_name + "\" transitioned into self.")
		return
	CURRENT_STATE.exit()
	CURRENT_STATE = new_state
	CURRENT_STATE.enter()
