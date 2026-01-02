class_name Hud extends CanvasLayer

func _on_being_status_set_max_health(max_health: float) -> void:
	$HBoxContainer/ProgressBar.max_value = max_health

func _on_being_status_set_cur_health(new_health: float) -> void:
	$HBoxContainer/ProgressBar.value = new_health
