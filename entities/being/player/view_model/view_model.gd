@tool

class_name ViewModel extends Node3D

@export var MOVEMENT_PIVOT: Node3D
@export var RECOIL_PIVOT: Node3D
@export var MESH_INSTANCE: MeshInstance3D
@export var HELD_ITEM:HeldItem:
	set(v):
		HELD_ITEM = v
		if Engine.is_editor_hint(): load_weapon()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_weapon()

func load_weapon() -> void:
	MOVEMENT_PIVOT.position = HELD_ITEM.offset
	MESH_INSTANCE.rotation = HELD_ITEM.rotation
	MESH_INSTANCE.scale = HELD_ITEM.scale
	MESH_INSTANCE.mesh = HELD_ITEM.mesh
