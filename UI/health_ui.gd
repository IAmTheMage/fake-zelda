extends Node2D

var start_life: int = 6;

@export var player: Node2D;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HealthRepresentation.play("default")
	$HealthRepresentation.sprite_frames.set_animation_loop('default', false)
	player.TakeDamage.connect(take_damage)
	
	$Life/AnimatedSprite2D.play("complete")
	$Life2/AnimatedSprite2D.play("complete")
	$Life3/AnimatedSprite2D.play("complete")

func take_damage(damage) -> void:
	start_life -= damage;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start_life == 5 and $HealthRepresentation.animation != '5':
		$HealthRepresentation.sprite_frames.set_animation_loop('5', false)
		$HealthRepresentation.play("5")
		
		$Life3/AnimatedSprite2D.play("half")
	elif start_life == 4 and $HealthRepresentation.animation != '4':
		$HealthRepresentation.sprite_frames.set_animation_loop('4', false)
		$HealthRepresentation.play("4")
		
		$Life3/AnimatedSprite2D.play("inexistent")
		
	elif start_life == 3 and $HealthRepresentation.animation != '3':
		$HealthRepresentation.sprite_frames.set_animation_loop('3', false)
		$HealthRepresentation.play("3")
		
		$Life2/AnimatedSprite2D.play("half")
		
	elif start_life == 2 and $HealthRepresentation.animation != '2':
		$HealthRepresentation.sprite_frames.set_animation_loop('2', false)
		$HealthRepresentation.play("2")
		
		$Life2/AnimatedSprite2D.play("inexistent")
		
	elif start_life == 1 and $HealthRepresentation.animation != '1':
		$HealthRepresentation.sprite_frames.set_animation_loop('1', false)
		$HealthRepresentation.play("1")
		
		$Life/AnimatedSprite2D.play("half")
		
	elif start_life == 0:
		get_tree().change_scene_to_file("res://game_over.tscn")
