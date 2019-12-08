extends Node2D

var screen_size
var screen_buffer = 0

onready var DummyRealm = get_node("DummyRealm")

var dirs = [
	Vector2(0, -1),
	Vector2(1, 0),
	Vector2(0, 1),
	Vector2(-1, 0)
]

func _ready ():
	screen_size = get_viewport_rect().size
	
	get_node("LargeAsteroid1").set_velocity_random()
	get_node("LargeAsteroid2").set_velocity_random()
	get_node("LargeAsteroid3").set_velocity_random()
	
	for dir in range(0, 4):
		copy_asteroid(get_node("LargeAsteroid1"), dirs[dir])
		copy_asteroid(get_node("LargeAsteroid2"), dirs[dir])
		copy_asteroid(get_node("LargeAsteroid3"), dirs[dir])

func copy_ship (ship : KinematicBody2D, dir : Vector2) -> void:
	var ship2 = preload("res://Ship/Ship.tscn").instance()
	ship2.make_dummy()
	ship2.position = ship.position + Vector2(screen_size.x * dir.x, screen_size.y * dir.y)
	ship2.rotation = ship.rotation
	ship.add_child(ship2)

func copy_asteroid (asteroid : RigidBody2D, dir : Vector2) -> void:
	var asteroid2 = null
	
	if asteroid is LargeAsteroid:
		asteroid2 = preload("res://Asteroids/LargeAsteroid/LargeAsteroid.tscn").instance()
	
	asteroid2.make_dummy()
	asteroid2.set_mode(1)
	asteroid2.position = Vector2(screen_size.x * dir.x, screen_size.y * dir.y)
	asteroid2.rotation = asteroid.rotation
	asteroid.add_child(asteroid2)

#func _physics_process (delta):
#	for child in DummyRealm.get_children():
#		DummyRealm.remove_child(child)
#		child.free()

func _process (delta):
	var ship = get_node("Ship")
	ship.position.x = wrapf(ship.position.x, -screen_buffer, screen_size.x + screen_buffer)
	ship.position.y = wrapf(ship.position.y, -screen_buffer, screen_size.y + screen_buffer)

func _on_Ship_death():
	pass
