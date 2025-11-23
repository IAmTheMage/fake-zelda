extends Node2D
class_name TreeObj;


@export var timer: Timer;


func play_reverse(anim_name: String) -> void:
	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	
	var frames: Array[Texture2D] = sprite.sprite_frames.get_animation_frames(anim_name)
	var reversed: Array[Texture2D] = frames.duplicate()
	reversed.reverse()

	var rev_name := anim_name + "_reverse"

	if sprite.sprite_frames.has_animation(rev_name):
		sprite.sprite_frames.remove_animation(rev_name)

	sprite.sprite_frames.add_animation(rev_name)

	for frame in reversed:
		sprite.sprite_frames.add_frame(rev_name, frame)

	sprite.play(rev_name)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = 1.0;
	timer.connect("timeout", start_first_animation)
	timer.start()
	$AnimatedSprite2D.connect("animation_finished", finish_first_animation)

func start_first_animation():
	print_debug('Starting first animation')
	$AnimatedSprite2D.play_backwards("idle")
	$AnimatedSprite2D.sprite_frames.set_animation_loop('idle', false)
	timer.stop()

func finish_first_animation():
	if $AnimatedSprite2D.animation == 'idle':
		$AnimatedSprite2D.play_backwards("idle2")
