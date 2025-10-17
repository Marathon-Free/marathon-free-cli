class_name MenuManager extends Control

# Current menu
var c_menu: Menu
var menus: Array[Menu] = []
var prev_menus: Array[Menu] = []

func _ready() -> void:
	load_menus()
	c_menu = menus[0]
	print(c_menu.name)

func load_menus() -> void: 
	for child in get_children():
		assert(child is Menu, "\"" + name + "\"'s child \"" + child.name + "\" is not a Menu")
		menus.append(child)

func switch_menu(m_name: StringName, fowards := false) -> void:
	for menu in menus:
		if menu.name == m_name: 
			prev_menus.append(c_menu)
			c_menu = menu
			return
	push_error(name + ": menu \"" + m_name + "\" not found")
