class_name BeingStatus
extends Node

@export_range(0.1, 1200.0, 0.01, "or_greater") var max_health := 100.0:
	set(v):
		max_health = v
		set_max_health.emit(max_health)
@export_range(0.0, 1200.0, 0.01, "or_greater") var max_shield := 0.0
@export_range(0.0, 1200.0, 0.01, "or_greater") var max_armor := 0.0
@export_range(0.1, 1200.0, 0.01, "or_greater") var health := 100.0:
	set(v):
		health = v
		set_cur_health.emit(health)
@export_range(0.0, 1200.0, 0.01, "or_greater") var shield := 0.0
@export_range(0.0, 1200.0, 0.01, "or_greater") var armor := 0.0
@export_range(0.1, 0.99, 0.01, "exp") var armor_strength := 0.1

signal set_max_health(max_health: float)
signal set_cur_health(new_health: float)

func damage(amount: float) -> void:
	health = health - amount

func _ready() -> void:
	set_max_health.emit(max_health)
	set_cur_health.emit(health)
