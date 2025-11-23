extends State
class_name Mob1SideIdle

@export var detector: Area2D
@export var MAX_DISTANCE: int = 400
@export var anim: AnimatedSprite2D
@export var mob: CharacterBody2D
@export var SPEED: float = 150.0

var counter: int = 1
var direction := 1
var initialized := false
var reset_counter = true

var left_target: Area2D
var right_target: Area2D
var current_target: Area2D

# Novas flags para tratar do spawn no left_target
var spawned_on_left := false
var has_left_once := false

const ARRIVAL_THRESHOLD := 5.0


func _spawn_targets():
	# LEFT TARGET -----------------------------------
	left_target = Area2D.new()
	var left_shape := CollisionShape2D.new()
	var left_rect := RectangleShape2D.new()
	left_rect.size = Vector2(32, 32)
	left_shape.shape = left_rect
	left_target.add_child(left_shape)

	var left_icon := Sprite2D.new()
	#left_icon.texture = preload("res://scripts/AI/Mob1/icon.svg")
	left_icon.modulate = Color(1, 0, 0, 0.5)
	left_icon.scale = Vector2(0.5, 0.5)
	left_target.add_child(left_icon)

	# spawn do left exatamente na posição do mob (conforme você descreveu)
	left_target.global_position = mob.global_position;


	# RIGHT TARGET -----------------------------------
	right_target = Area2D.new()
	var right_shape := CollisionShape2D.new()
	var right_rect := RectangleShape2D.new()
	right_rect.size = Vector2(32, 32)
	right_shape.shape = right_rect
	right_target.add_child(right_shape)

	var right_icon := Sprite2D.new()
	#right_icon.texture = preload("res://scripts/AI/Mob1/icon.svg")
	right_icon.modulate = Color(0, 1, 0, 0.5)
	right_icon.scale = Vector2(0.5, 0.5)
	right_target.add_child(right_icon)

	right_target.global_position = mob.global_position + Vector2(MAX_DISTANCE, 0)


	# Adiciona na cena
	get_tree().current_scene.add_child(left_target)
	get_tree().current_scene.add_child(right_target)


func Enter():
	reset_counter = true

	if not initialized:
		_spawn_targets()
		initialized = true

	# Detecta se nasceu no left_target (distance 0 ou muito pequena)
	spawned_on_left = abs(mob.global_position.x - left_target.global_position.x) <= ARRIVAL_THRESHOLD
	# Ainda não saiu do left após spawn
	has_left_once = false

	# Começa indo para o right_target (porque nasceu no left)
	current_target = right_target
	direction = 1

	anim.play("side_walk")
	anim.flip_h = direction > 0

	if not detector.is_connected("detect", Callable(self, "_on_detect_player")):
		detector.connect("detect", Callable(self, "_on_detect_player"))


func _on_detect_player(body):
	if body.name == "Player":
		var global_player_pos = body.global_position

		if global_player_pos.x < mob.global_position.x and direction < 0:
			Transition.emit(self, "sideattack")
			reset_counter = false

		elif global_player_pos.x > mob.global_position.x and direction > 0:
			Transition.emit(self, "sideattack")
			reset_counter = false


func Physics_Update():
	# Se estiver suficientemente longe do left_target após spawn, marcamos que saiu ao menos uma vez
	if spawned_on_left and not has_left_once:
		if abs(mob.global_position.x - left_target.global_position.x) > ARRIVAL_THRESHOLD:
			has_left_once = true
			# após sair, podemos considerar chegadas futuras ao left normalmente

	var tx = current_target.global_position.x

	# Check chegada
	if abs(mob.global_position.x - tx) <= ARRIVAL_THRESHOLD:
		# Se chegou no left_target, só contamos/atuamos se já tiver saído ao menos uma vez
		if current_target == left_target:
			if spawned_on_left and not has_left_once:
				# Ignora essa chegada — é a chegada "inicial" por spawn; não incrementa nem troca ainda.
				# (Se você quiser que o mob imediatamente saia novamente, mantemos current_target = right_target e direção = 1)
				# Para garantir que ele saia, forçamos direção para direita:
				current_target = right_target
				direction = 1
				anim.flip_h = direction > 0
				# não incrementa counter aqui
			else:
				# chegada válida no left (após ter saído)
				# troca target para right e incrementa contador de ciclos
				current_target = right_target
				direction = 1
				anim.flip_h = direction > 0
				counter += 1

		# Se chegou no right_target, sempre troca para left_target (e incrementa)
		elif current_target == right_target:
			current_target = left_target
			direction = -1
			anim.flip_h = direction > 0
			counter += 1

	# Movimento
	mob.velocity = Vector2(direction * SPEED, 0)
	mob.move_and_slide()


func Update():
	# só faz a decisão se estiver no LEFT TARGET e se **não** for a chegada inicial ignorada
	var on_left = abs(mob.global_position.x - left_target.global_position.x) <= ARRIVAL_THRESHOLD

	# só permite decisionstate se chegou ao left após ter saído ao menos uma vez
	if counter >= 3 and on_left and (not spawned_on_left or has_left_once):
		Transition.emit(self, "decisionstate")


func Exit():
	if reset_counter:
		counter = 1

	# desconecta detector para evitar múltiplas conexões em reentradas
	if detector.is_connected("detect", Callable(self, "_on_detect_player")):
		detector.disconnect("detect", Callable(self, "_on_detect_player"))
