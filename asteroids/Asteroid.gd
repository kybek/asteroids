extends RigidBody2D

class_name Asteroid

const MADE_IN_HEAVEN = 1.0

const VELOCITY = 50.0 * MADE_IN_HEAVEN

var screen_size
const screen_buffer = 0

var is_dummy := false

func _integrate_forces(state):
	if is_dummy:
		return
	
	var xform = state.get_transform()
	
	if xform.origin.x > screen_size.x - screen_buffer:
		xform.origin.x = -screen_buffer
		position.x = xform.origin.x
	
	if xform.origin.x < -screen_buffer:
		xform.origin.x = screen_size.x + screen_buffer
		position.x = xform.origin.x
	
	if xform.origin.y > screen_size.y + screen_buffer:
		xform.origin.y = -screen_buffer
		position.y = xform.origin.y
	
	if xform.origin.y < -screen_buffer:
		xform.origin.y = screen_size.y + screen_buffer
		position.y = xform.origin.y
	
	state.set_transform(xform)

func _ready ():
	screen_size = get_viewport_rect().size
	set_friction(0.0)

func set_velocity_random () -> void:
	randomize()
	set_linear_velocity(Vector2(2.0 * randf() - 1.0, 2.0 * randf() - 1.0).normalized() * VELOCITY)

func make_dummy ():
	if is_dummy:
		return
	
	is_dummy = true
	set_linear_velocity(Vector2(0.0, 0.0))