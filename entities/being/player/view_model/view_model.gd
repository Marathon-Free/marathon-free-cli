@tool

class_name ViewModel extends Node3D

@export var MOVEMENT_PIVOT: Node3D
@export var RECOIL_PIVOT: Node3D
@export var MESH_INSTANCE: MeshInstance3D
@export var HELD_ITEM:HeldItem:
	set(v):
		HELD_ITEM = v
		if Engine.is_editor_hint(): load_held_item()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_held_item()

func load_held_item() -> void:
	MOVEMENT_PIVOT.position = HELD_ITEM.offset
	MESH_INSTANCE.rotation = HELD_ITEM.rotation
	MESH_INSTANCE.scale = HELD_ITEM.scale
	MESH_INSTANCE.mesh = HELD_ITEM.mesh

func point_held_item(global_point: Vector3, delta: float) -> void:
	var currently_facing := -MOVEMENT_PIVOT.global_transform.basis.z
	var vector_to := global_point - MOVEMENT_PIVOT.global_position
	
	var axis := currently_facing.cross(vector_to).normalized()
	var angle := currently_facing.angle_to(vector_to)
	
	MOVEMENT_PIVOT.global_rotate(axis, lerpf(0.0, angle, 2*delta))
	MOVEMENT_PIVOT.rotation.z = 0
	#print(MOVEMENT_PIVOT.global_rotation)
