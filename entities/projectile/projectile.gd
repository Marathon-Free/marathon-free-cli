class_name Projectile
extends RigidBody3D

@export var AREA: Area3D
@export var TIMER: Timer

func _ready() -> void:
	pass
	#AREA.body_entered.connect(proj_collide)

func fire(new_vel: Vector3) -> void:
	apply_central_impulse(new_vel)
	TIMER.wait_time = 10
	TIMER.start()
	await TIMER.timeout
	queue_free()

func proj_collide() -> void:
	pass
 
func _physics_process(_delta: float) -> void:
	pass
	
	#linear_velocity = linear_velocity.lerp(Vector3.ZERO, 0.01 * delta)
	#linear_velocity += get_gravity()
	#
	#print("ACK")
	
	
	#var collision := move_and_collide(velocity * delta)
	#print("test")
	#if !collision: return
	#print("collider exists")
	#queue_free()
