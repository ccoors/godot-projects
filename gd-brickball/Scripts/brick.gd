extends Node2D

class_name Brick

@export var start_health: int = 1

var health: int = 0;
func _ready() -> void:
	%Particles.one_shot = true
	%Particles.set_emitting(false)
	health = start_health

	match randi_range(0, 4):
		0:
			modulate = Color(1.0, 0.0, 0.0, 1.0)
		1:
			modulate = Color(1.0, 1.0, 0.0, 1.0)
		2:
			modulate = Color(0.0, 1.0, 0.0, 1.0)
		3:
			modulate = Color(1.0, 0.0, 1.0, 1.0)
		4:
			modulate = Color(0.0, 1.0, 1.0, 1.0)


func hit(particle_direction: Vector2):
	%AudioBounceBrick.play()
	health -= 1
	%Sprite.modulate.a = float(health)/start_health

	if health < 1:
		%Particles.direction = particle_direction
		%Particles.set_emitting(true)
		%Sprite.hide()
		%BrickBody.queue_free()

func _on_audio_bounce_brick_finished() -> void:
	if health < 1 and not %Particles.emitting:
		queue_free()

func _on_particles_finished() -> void:
	if health < 1 and not %AudioBounceBrick.playing:
		queue_free()
