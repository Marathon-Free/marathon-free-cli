extends Menu

func _ready() -> void:
	$VBoxContainer/Resume.visible = Global.current_level != null
	Global.open_level.connect(set_resume_visible)

func set_resume_visible(level: Level) -> void:
	$VBoxContainer/Resume.visible = level != null

func options() -> void:
	transition.emit(&"OptionsMenu", true)

func test_map() -> void:
	Global.load_level(preload("res://levels/dev_level.tscn"))

func quit() -> void:
	get_tree().quit()
