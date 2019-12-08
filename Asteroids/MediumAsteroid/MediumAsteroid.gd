extends Asteroid

class_name MediumAsteroid

signal destroy_medium_asteroid (asteroid)

func destroy (direction : Vector2):
	destroyed_direction = direction
	print("medium asteroid destroyed")
	emit_signal("destroy_medium_asteroid", self)