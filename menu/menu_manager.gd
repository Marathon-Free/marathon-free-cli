class_name MenuManager extends Control

# Current menu
var c_menu: Menu
var menus: Array[Menu] = []
var prev_menus: Array[Menu] = []

func _ready() -> void:
	load_menus()
	c_menu = menus[0]
	c_menu.transition.connect(switch_menu_by_name)
	c_menu.enter()
	c_menu.visible = true
	#print(c_menu.name)

func load_menus() -> void: 
	for child in get_children():
		assert(child is Menu, "\"" + name + "\"'s child \"" + child.name + "\" is not a Menu")
		menus.append(child)
		(child as Menu).visible = false

func switch_menu_by_name(m_name: StringName, fowards := false) -> void:
	for menu in menus:
		if menu.name == m_name: 
			switch_menu(menu, fowards)
			return
	push_error(name + ": menu \"" + m_name + "\" not found")

func switch_menu(menu: Menu, fowards := false) -> void:
	if fowards: prev_menus.append(c_menu)
	c_menu.visible = false
	c_menu.exit()
	c_menu.transition.disconnect(switch_menu_by_name)
	c_menu = menu
	c_menu.transition.connect(switch_menu_by_name)
	c_menu.enter()
	c_menu.visible = true

func back_menu() -> void:
	var menu_pos := prev_menus.size() - 1
	if menu_pos < 0: return
	var menu := prev_menus[menu_pos]
	prev_menus.remove_at(menu_pos)
	switch_menu(menu)
