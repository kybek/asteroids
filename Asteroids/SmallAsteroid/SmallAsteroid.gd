extends Asteroid

class_name SmallAsteroid

signal destroy_small_asteroid (asteroid)

func destroy (direction : Vector2):
	destroyed_direction = direction
	print("small asteroid destroyed")
	emit_signal("destroy_small_asteroid", self)