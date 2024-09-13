extends Node2D

var menu = preload("res://Scenes/Menu.tscn")

func _input(event):
	if event is InputEventMouseButton:
		get_tree().change_scene_to_packed(menu)
