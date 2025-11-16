extends State
class_name Mob1SideIdle

@export var MAX_DISTANCE: int = 400
@export var anim: AnimatedSprite2D
@export var mob: CharacterBody2D
@export var SPEED: float = 150.0

var direction := 1
var start_position := Vector2.ZERO

func Enter():
	anim.flip_h = true;
	anim.play("side_walk")
	start_position = mob.global_position

func Physics_Update():
	#print_debug("UPDATE");
	# Movimento horizontal baseado na direção
	var movement = Vector2(direction, 0)
	
	

	mob.velocity = movement * SPEED
	mob.move_and_slide()

	# Distância percorrida
	var dist = mob.global_position.distance_to(start_position)

	# Quando atingir a distância máxima, inverte direção e redefine ponto inicial
	if dist >= MAX_DISTANCE:
		direction *= -1
		start_position = mob.global_position
		anim.flip_h = direction > 0   # Inverte o sprite se estiver indo para a esquerda
