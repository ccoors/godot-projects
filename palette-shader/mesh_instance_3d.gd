extends MeshInstance3D

@export var speed: float = 5.0


func _process(delta: float) -> void:
	if %RotateCheckBox.button_pressed:
		rotation += speed * delta * Vector3(0.1, 0.1, 0.1)
