extends Menu

func options() -> void:
	transition.emit(&"OptionsMenu", true)

func test_map() -> void:
	Global.load_level(preload("res://levels/dev_level.tscn"))

func quit() -> void:
	get_tree().quit()
