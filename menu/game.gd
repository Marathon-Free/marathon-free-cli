class_name Game extends Node

@onready var menus := $Menus as CanvasLayer
@onready var menu_manager := $Menus/MenuManager as MenuManager
@onready var gameplay := $Gameplay as CanvasLayer

#@export var default_level

var c_level: Level

func _ready() -> void:
	Global.open_level.connect(open_level)

func _process(_delta: float) -> void:
	if Input.is_action_just_released("menu"):
		menu_manager.back_menu()

func open_level(level: Level) -> void:
	if c_level: c_level.queue_free()
	c_level = level
	$Gameplay.add_child(c_level)
	menu_off()

func toggle_menu() -> void:
	if menus.visible: menu_off()
	else: menu_on()

func menu_on() -> void:
	menus.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if c_level and Global.pausable:
		c_level.set_process(false)
		c_level.set_process_input(false)
		c_level.set_physics_process(false)

func menu_off() -> void:
	menus.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if c_level and Global.pausable:
		c_level.set_process(true)
		c_level.set_process_input(true)
		c_level.set_physics_process(true)
