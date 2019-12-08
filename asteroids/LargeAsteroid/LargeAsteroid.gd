extends Asteroid

class_name LargeAsteroid

func destroy (direction : Vector2):
	print("destroyed")
	queue_free()