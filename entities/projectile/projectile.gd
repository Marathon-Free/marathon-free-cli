class_name Projectile
extends RigidBody3D

@export var area: Area3D
@export var timer: Timer

var damage: float
var grav_multi := 0.5

func fire(dir: Vector3, set_damage := 10.0) -> void:
	damage = set_damage
	area.body_entered.connect(proj_collide)
	apply_central_impulse(dir)
	timer.start()
	await timer.timeout
	queue_free()

func proj_collide(body: Node3D) -> void:
	if not body is PhysicsBody3D: return
	for child in body.get_children():
		if child is BeingStatus:
			child.damage(damage)
			queue_free()
			break
 
func _physics_process(_delta: float) -> void:
	if get_colliding_bodies().size() > 0:
		queue_free()
