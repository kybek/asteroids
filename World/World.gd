extends Node2D

var screen_size
var screen_buffer = 0

var dirs = [
	Vector2(0, -1),
	Vector2(1, 0),
	Vector2(0, 1),
	Vector2(-1, 0)
]

func _ready ():
	screen_size = get_viewport_rect().size
	
	for i in range(1, 4):
		get_node("LargeAsteroid" + str(i)).set_velocity_random()
		get_node("LargeAsteroid" + str(i)).connect("destroy_large_asteroid", self, "destroy_large_asteroid")
		
		for dir in range(0, 4):
			copy_asteroid(get_node("LargeAsteroid" + str(i)), dirs[dir])

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
	
	if asteroid is MediumAsteroid:
		asteroid2 = preload("res://Asteroids/MediumAsteroid/MediumAsteroid.tscn").instance()
	
	if asteroid is SmallAsteroid:
		asteroid2 = preload("res://Asteroids/SmallAsteroid/SmallAsteroid.tscn").instance()
	
	asteroid2.make_dummy()
	asteroid2.set_mode(1)
	asteroid2.position = Vector2(screen_size.x * dir.x, screen_size.y * dir.y)
	asteroid2.rotation = asteroid.rotation
	asteroid.add_child(asteroid2)

func destroy_large_asteroid (asteroid : LargeAsteroid):
	var position := asteroid.position
	var velocity := asteroid.get_linear_velocity()
	var direction := asteroid.destroyed_direction
	
	asteroid.queue_free()
	
	for i in range(0, 3):
		var new_asteroid = preload("res://Asteroids/MediumAsteroid/MediumAsteroid.tscn").instance()
		new_asteroid.position = position + direction.rotated(i * 120.0 / 180.0)
		new_asteroid.set_linear_velocity(velocity.rotated(i * 120.0 / 180.0))
		new_asteroid.connect("destroy_medium_asteroid", self, "destroy_medium_asteroid")
		add_child(new_asteroid)
		
		for dir in range(0, 4):
			copy_asteroid(new_asteroid, dirs[dir])

func destroy_medium_asteroid (asteroid : MediumAsteroid):
	var position := asteroid.position
	var velocity := asteroid.get_linear_velocity()
	var direction := asteroid.destroyed_direction
	
	asteroid.queue_free()
	
	for i in range(0, 3):
		var new_asteroid = preload("res://Asteroids/SmallAsteroid/SmallAsteroid.tscn").instance()
		new_asteroid.position = position + direction.rotated(i * 120.0 / 180.0)
		new_asteroid.set_linear_velocity(velocity.rotated(i * 120.0 / 180.0))
		new_asteroid.connect("destroy_small_asteroid", self, "destroy_small_asteroid")
		add_child(new_asteroid)
		
		for dir in range(0, 4):
			copy_asteroid(new_asteroid, dirs[dir])

func destroy_small_asteroid (asteroid : SmallAsteroid) -> void:
	asteroid.queue_free()

var elapsed_time := 0.0

func _process (delta):
	elapsed_time += delta
	
	for child in get_children():
		if child is KinematicBody2D:
			child.position.x = wrapf(child.position.x, -screen_buffer, screen_size.x + screen_buffer)
			child.position.y = wrapf(child.position.y, -screen_buffer, screen_size.y + screen_buffer)

func _on_Ship_death():
	print(elapsed_time)
	queue_free()
