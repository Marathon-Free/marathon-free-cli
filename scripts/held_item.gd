class_name HeldItem extends Resource

@export_category("Identification")
@export var name: StringName
@export var nice_name: String
@export_category("Visual")
@export var mesh: Mesh
@export_category("Player View Model")
@export var offset :=  Vector3(0.6, -0.3, -0.4)
@export var rotation: Vector3
@export var scale := Vector3(1, 1, 1)
@export var recoil: Animation
@export_category("Attack")
@export var projectile := false
@export var refire_time := 0.5 
