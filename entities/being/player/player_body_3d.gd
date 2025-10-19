class_name PlayerBody3D extends CharacterBody3D

@onready var MOVEMENT_PLAYER := $MovementPlayer as AnimationPlayer
@onready var STANCE_PLAYER := $StancePlayer as AnimationPlayer
@onready var PIVOT_Y := $PivotY as Node3D
@onready var PIVOT_X := $PivotY/PivotX as Node3D
@onready var CAMERA := $PivotY/PivotX/Camera3D as Camera3D
@onready var RAY_CAST := $PivotY/PivotX/Camera3D/RayCast3D as RayCast3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Player controls, and much more, are in the state machine.

func _ready() -> void:
	pass
	#print("Ready")

func _physics_process(_delta: float) -> void:
	RAY_CAST.
	
	return
