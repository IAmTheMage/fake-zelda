extends CharacterBody2D

@export var anim: AnimatedSprite2D;

var SPEED = -150.0

func _ready() -> void:
	anim.sprite_frames.set_animation_loop("collision", false)
	anim.play("default")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	velocity = Vector2(1, 0) * SPEED

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		anim.play("collision")


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "collision":
		queue_free()
