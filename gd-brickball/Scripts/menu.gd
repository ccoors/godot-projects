extends Node2D

var brick = preload("res://Scenes/Brick.tscn")

func add_brick(pos: Vector2) -> void:
	var instance = brick.instantiate()
	add_child(instance)
	instance.position = pos
	instance.add_to_group("bricks")

func init_brick_rect(from: Vector2i, to: Vector2i) -> void:
	for x in range(from.x, to.x):
		for y in range(from.y, to.y):
			if (x + y) % 2 == 0:
				add_brick(Vector2(39 + x*38, 30 + y * 20))

func init_bricks() -> void:
	init_brick_rect(Vector2i(2, 2), Vector2i(18, 8))
	#init_brick_rect(Vector2i(2, 18), Vector2i(18, 22))
	init_brick_rect(Vector2i(2, 8), Vector2i(4, 19))
	init_brick_rect(Vector2i(16, 8), Vector2i(18, 19))

func _ready() -> void:
	for ball in get_tree().get_nodes_in_group("balls"):
		ball.direction = Vector2(randf()-.5, randf()-.5)
	init_bricks()

func _process(_delta: float) -> void:
	var brick_health = 0
	for b in get_tree().get_nodes_in_group("bricks"):
		brick_health += b.health
	if not brick_health:
		init_bricks()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level.tscn")
