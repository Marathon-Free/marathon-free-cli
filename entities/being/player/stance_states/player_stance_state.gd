class_name PlayerStanceState extends State

var PLAYER: PlayerBody3D
var ANIM_PLAYER: AnimationPlayer

@export_range(0.1, 3.0, 0.1, "exp", "or_greater", "or_less") var SPEED_MULTIPLIER := 1.0
@export_range(0.1, 3.0, 0.1, "exp", "or_greater", "or_less") var ACCEL_MULTIPLIER := 1.0
@export_range(0.1, 3.0, 0.1, "exp", "or_greater", "or_less") var FRICT_MULTIPLIER := 1.0


func _ready() -> void:
	assert(owner is PlayerBody3D)
	await owner.ready
	PLAYER = owner
	#await PLAYER.ANIM_PLAYER.ready
	ANIM_PLAYER = PLAYER.STANCE_PLAYER
