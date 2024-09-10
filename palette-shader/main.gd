extends Node3D

var files: PackedStringArray


func _ready() -> void:
	var viewport_width: float = get_viewport().get_visible_rect().size.x
	var sprite_scale: float = viewport_width / %Sprite2D.texture.get_size().x
	%Sprite2D.set_scale(Vector2(sprite_scale, sprite_scale))

	%DitherSlider.value = %Sprite2D.material.get_shader_parameter("threshold")

	files = DirAccess.get_files_at("res://palettes")
	var popup: PopupMenu = %PaletteSelector.get_popup()
	var default_select: int = 0
	for idx in files.size():
		var file: String = files[idx]
		if file.ends_with(".png.import"):
			popup.add_item(file.left(-11), idx)
		if file == "commodore64.png.import":
			default_select = idx
	popup.id_pressed.connect(popup_selected)
	popup_selected(default_select)


func popup_selected(id: int) -> void:
	var texture: Texture = load("res://palettes/%s" % files[id].left(-7))
	%Sprite2D.material.set_shader_parameter("palette_image", texture)
	%PaletteSelector.text = "Palette: %s" % files[id].left(-11)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == 32 and event.pressed and not event.echo:
		%VBoxContainer.visible = !%VBoxContainer.visible


func _on_v_slider_value_changed(value: float) -> void:
	%Sprite2D.material.set_shader_parameter("threshold", value)


func _on_check_box_toggled(toggled_on: bool) -> void:
	%Sprite2D.visible = toggled_on
