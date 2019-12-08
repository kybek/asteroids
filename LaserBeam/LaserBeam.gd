extends KinematicBody2D

class_name LaserBeam

var VELOCITY := 250.0
var direction := Vector2(0.0, -1.0)

func _process (delta):
	var collision = move_and_collide(direction * VELOCITY * delta, false)
	
	if collision != null:
		print(collision.collider)
		if collision.collider is Asteroid:
			var asteroid = collision.collider
			asteroid.destroy(direction)
		
		queue_free()

func _on_Life_timeout():
	queue_free()
