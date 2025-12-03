class_name PlayerStanceState extends State

var PLAYER: PlayerBody3D
var ANIM_PLAYER: AnimationPlayer

@export var SPEED_MULTIPLIER := 1.0

func _ready() -> void:
	assert(owner is PlayerBody3D)
	await owner.ready
	PLAYER = owner
	#await PLAYER.ANIM_PLAYER.ready
	ANIM_PLAYER = PLAYER.STANCE_PLAYER
