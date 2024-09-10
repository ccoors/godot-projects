@tool

class_name Paddle

extends Node2D

var sprite_size: int = 16
var sprite_offset: int = 2
var sprite_side_size: int = 14

@export
var follow_ball: Ball = null

@export_range(20, 200) var size: int = 60 :
	get:
		return size
	set(value):
		if value < 20:
			value = 20
		if value > 200:
			value = 200
		if is_ready:
			%center.scale.x = value / 6.9
			%left.position.x = -value/2.
			%right.position.x = value/2.
			%shape.shape.height = value + 30
		size = value
		update_position()

var held_balls: Array[Ball] = []

func catch_ball(ball: Ball):
	if ball not in held_balls:
		held_balls.push_back(ball)
		ball.ball_caught()

	%center.set_animation("holding")
	%left.set_animation("holding")
	%right.set_animation("holding")

var mouse_position : Vector2 = Vector2.ZERO
var screen_size : Vector2 = Vector2.ZERO
var is_ready: bool = false

func _ready() -> void:
	screen_size = get_viewport_rect().size
	is_ready = true
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "size", size, .5)

func bounce() -> void:
	%center.play("bounce")
	%left.play("bounce")
	%right.play("bounce")

func _on_center_animation_finished() -> void:
	%center.play("default")
	%left.play("default")
	%right.play("default")

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if follow_ball:
		update_position(delta)
		return

	if Input.is_action_just_pressed("paddle_size_plus"):
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "size", size + 50, .5)
	if Input.is_action_just_pressed("paddle_size_minus"):
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "size", size - 50, .5)

	if held_balls:
		var ball_distance = size/(len(held_balls) + 1)
		var x = position.x - size/2. + ball_distance
		for ball in held_balls:
			ball.position.x = x
			x += ball_distance
			ball.position.y = position.y - 16

var total_time: float = 0
func update_position(delta: float = 0):
	total_time += delta
	if Engine.is_editor_hint():
		return
	if follow_ball:
		position.x = follow_ball.position.x + 20 * sin(
			total_time*5
		)
	else:
		position.x = mouse_position.x
	position.x = clamp(position.x, size/2. + sprite_side_size, screen_size.x - size/2. - sprite_side_size)

func _input(event):
	if Engine.is_editor_hint():
		return
	if event is InputEventMouseMotion:
		mouse_position = event.position
		update_position()
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			for ball in held_balls:
				ball.ball_released()
			held_balls = []
			%center.play("default")
			%left.play("default")
			%right.play("default")
