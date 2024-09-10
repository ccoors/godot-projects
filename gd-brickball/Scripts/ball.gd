@tool

extends RigidBody2D

class_name Ball

@export
var direction: Vector2 = Vector2.ZERO :
	get:
		return direction
	set(value):
		value = value.normalized()
		if abs(value.y) < 0.2:
			value.y = signf(value.y) * 0.2
			if value.y == 0.0:
				value.y = -0.2
			value = value.normalized()
		direction = value


@export
var speed: float = 800.0

@export
var acceleration: float = 25.0

@export
var max_speed: float = 3000

@export
var can_die: bool = true

var caught: bool = false

func _ready() -> void:
	process_mode = PROCESS_MODE_PAUSABLE

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if not freeze:
		speed = clamp(speed+(delta*acceleration), 200, max_speed)
		%Sprite.material.set_shader_parameter("dir", direction * (speed / 1600.))
	else:
		%Sprite.material.set_shader_parameter("dir", Vector2.ZERO)

func ball_caught():
	set_freeze_enabled(true)

func ball_released():
	position.y -= 10
	set_freeze_enabled(false)
	direction = Vector2(randf_range(-1., 1.), -5)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if freeze:
		return
	var velocity = speed * direction * delta
	var collision = move_and_collide(velocity)
	if (collision):
		bounce_off(collision)

func bounce_off(collision: KinematicCollision2D):
	var handled_collision = false
	var collision_shape = collision.get_collider_shape()
	var collided_with = collision.get_collider().get_parent()
	if collided_with is Paddle:
		var collision_position = collision.get_position().x
		var capsule_height = collision.get_collider_shape().shape.height/2.
		var paddle_pos = collided_with.position.x
		var delta_pos = collision_position - paddle_pos
		var relative_pos = delta_pos / capsule_height
		if abs(relative_pos) < .95:
			var angle = remap(relative_pos, -.95, .95, 0.5, PI-0.5)
			direction = Vector2.LEFT.rotated(angle)
			handled_collision = true

		%AudioBouncePaddle.play()
		collided_with.bounce()
	elif collided_with is Brick:
		collided_with.hit(direction)
	elif collided_with is Ball:
		pass
	else:
		if can_die and collision_shape.has_meta("death") and collision_shape.get_meta("death"):
			queue_free()
		%AudioBounceWall.play()

	if not handled_collision:
		direction = direction.bounce(collision.get_normal())
