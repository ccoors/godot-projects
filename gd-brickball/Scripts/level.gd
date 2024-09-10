extends Node2D

var game_over: bool = false

func _ready() -> void:
	for brick in %Bricks.get_children():
		brick.add_to_group("bricks")
	for ball in get_tree().get_nodes_in_group("balls"):
		%Paddle.catch_ball(ball)

func _process(_delta: float) -> void:
	var brick_health = 0
	for brick in get_tree().get_nodes_in_group("bricks"):
		brick_health += brick.health
	if not game_over and not brick_health:
		game_over = true
		get_tree().set_pause(true)
		%UI.show()
		%Pause.hide()
		%GameOver.show()

	if not game_over and not get_tree().get_nodes_in_group("balls"):
		game_over = true
		get_tree().set_pause(false)
		%UI.show()
		%Pause.hide()
		%GameOver.show()

	if Input.is_action_just_pressed("interrupt") and not game_over:
		get_tree().set_pause(true)
		%UI.show()
		%Pause.show()

func _on_timer_timeout() -> void:
	%ClickToRelease.queue_free()

func _on_continue_button_pressed() -> void:
	get_tree().set_pause(false)
	if game_over:
		get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
	else:
		%UI.hide()
