extends KinematicBody2D

const MADE_IN_HEAVEN = 1.0

const MAX_VELOCITY = 200.0 * MADE_IN_HEAVEN
var velocity := Vector2(0.0, 0.0)
var direction := Vector2(0.0, -1.0)
const ROTATION_ANGLE := 10.0 * MADE_IN_HEAVEN
const BOOST_VELOCITY = 15.0 * MADE_IN_HEAVEN

var is_dummy := false

signal death

func rotate_cw (angle : float) -> void:
	direction = direction.rotated(angle / 180.0)
	rotate(angle / 180.0)

func rotate_ccw (angle : float) -> void:
	direction = direction.rotated(-angle / 180.0)
	rotate(-angle / 180.0)

func shoot () -> void:
	var pos_vec = Vector2(get_node("Shape").shape.extents.x / 4, -20).rotated(rotation)
	var aim_vec = Vector2(0, -1).rotated(rotation)
	
	var laser = preload("res://LaserBeam/LaserBeam.tscn").instance()
	laser.global_position = global_position + pos_vec
	laser.direction = aim_vec
	laser.rotate(rotation)
	get_tree().current_scene.add_child(laser)

func _process (delta):
	clamp(velocity.x, -MAX_VELOCITY, MAX_VELOCITY)
	clamp(velocity.y, -MAX_VELOCITY, MAX_VELOCITY)
	
	var collision = move_and_collide(velocity * delta, false, true, is_dummy)
	
	if collision != null:
		if not (collision.collider is LaserBeam):
			emit_signal("death")
	
	if is_dummy:
		return
	
	if Input.is_action_pressed("rotate_cw"):
		rotate_cw(ROTATION_ANGLE)
	
	if Input.is_action_pressed("rotate_ccw"):
		rotate_ccw(ROTATION_ANGLE)
	
	if Input.is_action_pressed("boost"):
		velocity = velocity + direction * BOOST_VELOCITY
	
	if Input.is_action_pressed("shoot"):
		if get_node("LaserTimer").time_left == 0:
			shoot()
			get_node("LaserTimer").start()

func make_dummy ():
	if is_dummy:
		return
	
	is_dummy = true