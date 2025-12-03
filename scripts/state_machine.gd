class_name StateMachine extends Node

@export var CURRENT_STATE: State
var states: Dictionary[StringName,State] = {}

@export var SHAPE_CAST: ShapeCast3D

signal new_state(state: State, stop_state: State)

var c_state: State

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

func on_child_transition(c_state_name: StringName) -> void:
	#print(c_state_name)
	var p_state := c_state
	c_state = states.get(c_state_name)
	
	if c_state == null: 
		push_error("State \"" + c_state_name + "\" does not exist.")
		return
	assert(c_state is State)
	if c_state == CURRENT_STATE: 
		push_error("State \"" + c_state_name + "\" transitioned into self.")
		return
	CURRENT_STATE.exit()
	CURRENT_STATE = c_state
	CURRENT_STATE.enter()
	new_state.emit(c_state, p_state)
