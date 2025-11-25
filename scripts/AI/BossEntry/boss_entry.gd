extends CharacterBody2D

@export var is_attacking = false
@export var fire_ball: PackedScene;
@export var player: Node2D;

func _ready() -> void:
	if not is_attacking:
		$AnimatedSprite2D.play("idle")
		$AnimatedSprite2D.sprite_frames.set_animation_loop("idle", false)
		$AudioStreamPlayer.play()
		$AnimatedSprite2D.scale = Vector2(0.2, 0.2)
		
	else:
		$AnimatedSprite2D.play("active")
		$Timer.start()


func _on_timer_timeout() -> void:
	var fire_ball_packed = fire_ball.instantiate()
	fire_ball_packed.global_position = $FireBallPos.global_position
	fire_ball_packed.move_vector = (player.global_position - global_position)
	get_tree().current_scene.add_child(fire_ball_packed)
