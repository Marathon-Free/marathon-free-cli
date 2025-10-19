extends Menu

@onready var mouse_sens_slider := %MouseSensitivity/MouseSlider as HSlider
@onready var mouse_sens_spin_box := %MouseSensitivity/MouseBox as SpinBox
@onready var controller_sens_slider := %ControllerStickSensitivity/StickSlider as HSlider
@onready var controller_sens_spin_box := %ControllerStickSensitivity/StickBox as SpinBox
@onready var v_sync_options := %VSyncOptions as OptionButton


enum input_type {
	SLIDER,
	SPIN_BOX,
	NONE
}

func _ready() -> void:
	mouse_sens_slider.value = Global.mouse_sensitivity
	mouse_sens_slider.value_changed.connect(_on_mouse_slider_value_changed)
	mouse_sens_spin_box.value = Global.mouse_sensitivity
	mouse_sens_spin_box.value_changed.connect(_on_mouse_box_value_changed)
	controller_sens_slider.value = Global.controller_sensitivity
	controller_sens_slider.value_changed.connect(_on_stick_slider_value_changed)
	controller_sens_spin_box.value = Global.controller_sensitivity
	controller_sens_spin_box.value_changed.connect(_on_stick_box_value_changed)
	v_sync_options.selected = Global.vsync
	v_sync_options.item_selected.connect(_on_v_sync_options_item_selected)

func set_mouse_sensitivity(value: float, source: input_type) -> void:
	Global.mouse_sensitivity = value
	match source:
		input_type.SLIDER:
			mouse_sens_spin_box.value = value
		input_type.SPIN_BOX:
			mouse_sens_slider.value = value
		input_type.NONE:
			mouse_sens_slider.value = value
			mouse_sens_spin_box.value = value

func set_controller_sensitivity(value: float, source: input_type) -> void:
	Global.controller_sensitivity = value
	match source:
		input_type.SLIDER:
			controller_sens_spin_box.value = value
		input_type.SPIN_BOX:
			controller_sens_slider.value = value
		input_type.NONE:
			controller_sens_slider.value = value
			controller_sens_spin_box.value = value



func _on_mouse_slider_value_changed(value: float) -> void:
	Global.mouse_sensitivity = value
	mouse_sens_spin_box.value = value

func _on_mouse_box_value_changed(value: float) -> void:
	Global.mouse_sensitivity = value
	mouse_sens_slider.value = value

func _on_stick_slider_value_changed(value: float) -> void:
	Global.controller_sensitivity = value
	controller_sens_spin_box.value = value

func _on_stick_box_value_changed(value: float) -> void:
	Global.controller_sensitivity = value
	controller_sens_slider.value = value

func _on_v_sync_options_item_selected(index: int) -> void:
	match index:
		0: Global.vsync = DisplayServer.VSYNC_DISABLED
		1: Global.vsync = DisplayServer.VSYNC_ENABLED
		2: Global.vsync = DisplayServer.VSYNC_ADAPTIVE
		3: Global.vsync = DisplayServer.VSYNC_MAILBOX
	print(Global.vsync, DisplayServer.window_get_vsync_mode())
