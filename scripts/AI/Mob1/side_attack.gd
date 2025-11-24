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
	if not timer.is_connected("timeout", Callable(self, "_on_side_attack_timer_timeout")):
		timer.connect("timeout", Callable(self, "_on_side_attack_timer_timeout"))
	if not detector.is_connected("body_exited", exit_area):
		detector.connect("body_exited", exit_area)
	shoot()
	

func exit_area(body):
	if body.name == "Player":
		
		if anim.animation == 'side_attack':
			anim.pause()
			timer.stop()
			Transition.emit(self, "statesideidle")

func shoot():

	var arrow = ArrowScene.instantiate()
	arrow.scale = Vector2.ONE * 0.25;
	arrow.global_position = LeftSpawner.global_position;
	
	
	if anim.flip_h:
		arrow.direction = -1
		arrow.scale = Vector2.ONE * -0.25;
		arrow.global_position = RightSpawner.global_position;
		
	get_tree().current_scene.add_child(arrow)

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == 'side_attack':
		anim.pause()
	timer.start()


func _on_side_attack_timer_timeout() -> void:
	print_debug("looop looop loooop")
	if anim.animation == 'side_attack':
		anim.play("side_attack")
	shoot()
	
func Exit():
	timer.disconnect("timeout", Callable(self, "_on_side_attack_timer_timeout"))
