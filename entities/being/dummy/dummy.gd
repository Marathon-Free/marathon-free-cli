class_name Dummy
extends StaticBody3D

var a: float
var b: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()
	pass # Replace with function body.

func update() -> void:
	$Label3D.text = str(a) + " / " + str(b)

func _on_being_status_max_health_changed(max_health: float) -> void:
	b = max_health
	update()


func _on_being_status_cur_health_changed(new_health: float) -> void:
	a = new_health
	print("ow (" + str(new_health) + ")")
	update()
