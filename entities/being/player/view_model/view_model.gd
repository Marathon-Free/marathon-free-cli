@tool

class_name ViewModel extends Node3D

@export var MOVEMENT_PIVOT: Node3D
@export var HAND_PIVOT: Node3D
@export var RECOIL_PIVOT: Node3D
@export var MESH_INSTANCE: MeshInstance3D
@export var held_item:HeldItem:
	set(v):
		held_item = v
		if Engine.is_editor_hint(): load_held_item()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_held_item()

func load_held_item() -> void:
	HAND_PIVOT.position = held_item.offset
	MESH_INSTANCE.rotation = held_item.rotation
	MESH_INSTANCE.scale = held_item.scale
	MESH_INSTANCE.mesh = held_item.mesh

func point_held_item(global_point: Vector3, delta: float) -> void:
	var currently_facing := -HAND_PIVOT.global_transform.basis.z
	var vector_to := global_point - HAND_PIVOT.global_position
	
	var axis := currently_facing.cross(vector_to).normalized()
	var angle := currently_facing.angle_to(vector_to)
	
	HAND_PIVOT.global_rotate(axis, lerpf(0.0, angle, 2*delta))
	HAND_PIVOT.rotation.z = 0
	#print(MOVEMENT_PIVOT.global_rotation)
