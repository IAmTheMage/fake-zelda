extends CharacterBody2D

@export var anim: AnimatedSprite2D;
var direction = 1
var xy_v = Vector2(1, 0)

var SPEED = -150.0

var applied_damage_on_player = 1;

func _ready() -> void:
	anim.sprite_frames.set_animation_loop("collision", false)
	anim.play("default")

func _physics_process(delta: float) -> void:
	# movimentação
	velocity = xy_v * SPEED * direction
	#print_debug(xy_v)
	move_and_slide()

	# rotação automática
	if xy_v.y == -1:
		rotation = deg_to_rad(270)   # apontar para cima
	elif xy_v.y == 1:
		rotation = deg_to_rad(90)    # apontar para baixo


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		anim.play("collision")
		direction = 0


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "collision":
		queue_free()
