extends State
class_name Mob1SideAttack

@export var anim: AnimatedSprite2D
@export var detector: Area2D;
@export var timer: Timer;

@export var ArrowScene: PackedScene;
@export var Mob: CharacterBody2D;
@export var LeftSpawner: Area2D;
@export var RightSpawner: Area2D;


func Enter():
	anim.play("side_attack")
	anim.sprite_frames.set_animation_loop("side_attack", false)
	timer.wait_time = 1.0;
	shoot()
	

func shoot():
	var arrow = ArrowScene.instantiate()
	if Mob.scale.x < 0:
		arrow.scale = Vector2.ONE * -0.25;
		arrow.global_position = RightSpawner.global_position;
		
	if Mob.scale.x > 0:
		arrow.scale = Vector2.ONE * 0.25;
		arrow.global_position = LeftSpawner.global_position;
		
	get_tree().current_scene.add_child(arrow)

func _on_animated_sprite_2d_animation_finished() -> void:
	anim.pause()
	timer.start()


func _on_side_attack_timer_timeout() -> void:
	anim.play("side_attack")
	shoot()
