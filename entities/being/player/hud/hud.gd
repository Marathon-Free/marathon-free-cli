class_name Hud extends CanvasLayer

#func _on_being_status_set_max_health(max_health: float) -> void:
	#$HBoxContainer/ProgressBar.max_value = max_health
#
#func _on_being_status_set_cur_health(new_health: float) -> void:
	#$HBoxContainer/ProgressBar.value = new_health


func _on_being_status_max_health_changed(max_health: float) -> void:
	$VBoxContainer/HBoxContainer/HealthBar.max_value = max_health


func _on_being_status_cur_health_changed(new_health: float) -> void:
	$VBoxContainer/HBoxContainer/HealthBar.value = new_health


func _on_being_status_max_armour_changed(max_armour: float) -> void:
	$VBoxContainer/HBoxContainer/ArmourBar.max_value = max_armour

func _on_being_status_cur_armour_changed(new_armour: float) -> void:
	$VBoxContainer/HBoxContainer/ArmourBar.value = new_armour


func _on_being_status_max_shield_changed(max_shield: float) -> void:
	$VBoxContainer/ShieldBar.max_value = max_shield


func _on_being_status_cur_shield_changed(new_shield: float) -> void:
	$VBoxContainer/ShieldBar.value = new_shield
