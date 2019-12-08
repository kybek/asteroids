extends Asteroid

class_name LargeAsteroid

signal destroy_large_asteroid (asteroid)

func destroy (direction : Vector2):
	destroyed_direction = direction
	print("large asteroid destroyed")
	emit_signal("destroy_large_asteroid", self)