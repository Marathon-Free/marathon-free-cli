class_name BeingStatus
extends Node

@export_range(0.1, 1200.0, 0.01, "or_greater") var max_health := 100.0:
	set(v):
		max_health = v
		max_health_changed.emit(max_health)
@export_range(0.0, 1200.0, 0.01, "or_greater") var max_armour := 0.0:
	set(v):
		max_armour = v
		max_armour_changed.emit(max_armour)
@export_range(0.0, 1200.0, 0.01, "or_greater") var max_shield := 0.0:
	set(v):
		max_shield = v
		max_shield_changed.emit(max_shield)
@export_range(0.1, 1200.0, 0.01, "or_greater") var health := 100.0:
	set(v):
		health = v
		cur_health_changed.emit(health)
@export_range(0.0, 1200.0, 0.01, "or_greater") var armour := 0.0:
	set(v):
		armour = v
		cur_armour_changed.emit(armour)
@export_range(0.0, 1200.0, 0.01, "or_greater") var shield := 0.0:
	set(v):
		shield = v
		cur_shield_changed.emit(shield)
@export_range(0.1, 0.99, 0.01, "exp") var armor_strength := 0.1

signal max_health_changed(max_health: float)
signal max_armour_changed(max_armour: float)
signal max_shield_changed(max_shield: float)
signal cur_health_changed(new_health: float)
signal cur_armour_changed(new_armour: float)
signal cur_shield_changed(new_shield: float)

func damage(amount: float) -> void:
	if shield:
		shield = maxf(shield - amount, 0)
		return
	var health_amount := amount * (1 - armor_strength)
	var armor_amount := amount - health_amount
	# Extra damage after armour is depleted is applied to health
	health_amount += maxf(armor_amount - armour, 0)
	armour = maxf(armour - armor_amount, 0)
	# Health is the only value that can go negative, for gibbing,
	# and death at health < 0 (rather than health <= 0)
	health -= health_amount

func _ready() -> void:
	max_health_changed.emit(max_health)
	max_armour_changed.emit(max_armour)
	max_shield_changed.emit(max_shield)
	cur_health_changed.emit(health)
	cur_armour_changed.emit(armour)
	cur_shield_changed.emit(shield)
