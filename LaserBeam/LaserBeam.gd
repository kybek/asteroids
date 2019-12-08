extends KinematicBody2D

var VELOCITY := 250.0
var direction := Vector2(0.0, -1.0)

func _ready ():
	direction = Vector2(randf(), randf())

func _process (delta):
	move_and_collide(direction * VELOCITY * delta)