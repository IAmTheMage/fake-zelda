extends State
class_name Mob1UpDownWalking

@export var detector: Area2D
@export var MAX_DISTANCE: int = 400
@export var anim: AnimatedSprite2D
@export var mob: CharacterBody2D
@export var SPEED: float = 150.0

var counter: int = 1
var direction := -1                # -1 = sobe (y decresce), 1 = desce (y aumenta)
var initialized := false
var reset_counter := true

var top_target: Area2D
var bottom_target: Area2D
var current_target: Area2D

# Flags análogas ao caso left/right
var spawned_on_top := false
var has_top_once := false

const ARRIVAL_THRESHOLD := 5.0


func _spawn_targets():
	# TOP TARGET -----------------------------------
	top_target = Area2D.new()
	var top_shape := CollisionShape2D.new()
	var top_rect := RectangleShape2D.new()
	top_rect.size = Vector2(32, 32)
	top_shape.shape = top_rect
	top_target.add_child(top_shape)

	var top_icon := Sprite2D.new()
	#top_icon.texture = preload("res://scripts/AI/Mob1/icon.svg")
	top_icon.modulate = Color(1, 0, 0, 0.5)
	top_icon.scale = Vector2(0.5, 0.5)
	top_target.add_child(top_icon)

	# spawn do top exatamente na posição do mob (conforme descrito)
	top_target.global_position = mob.global_position

	# BOTTOM TARGET -----------------------------------
	bottom_target = Area2D.new()
	var bot_shape := CollisionShape2D.new()
	var bot_rect := RectangleShape2D.new()
	bot_rect.size = Vector2(32, 32)
	bot_shape.shape = bot_rect
	bottom_target.add_child(bot_shape)

	var bot_icon := Sprite2D.new()
	#bot_icon.texture = preload("res://scripts/AI/Mob1/icon.svg")
	bot_icon.modulate = Color(0, 1, 0, 0.5)
	bot_icon.scale = Vector2(0.5, 0.5)
	bottom_target.add_child(bot_icon)

	# bottom fica MAX_DISTANCE abaixo do spawn
	bottom_target.global_position = mob.global_position + Vector2(0, MAX_DISTANCE)

	# Adiciona na cena
	get_tree().current_scene.add_child(top_target)
	get_tree().current_scene.add_child(bottom_target)


func Enter():
	reset_counter = true

	if not initialized:
		_spawn_targets()
		initialized = true

	# Detecta se nasceu no top_target (distance 0 ou muito pequena)
	spawned_on_top = abs(mob.global_position.y - top_target.global_position.y) <= ARRIVAL_THRESHOLD
	# Ainda não saiu do top após spawn
	has_top_once = false

	# Se nasceu no top, começa indo para bottom (descer); caso contrário, se nasceu no bottom, começa indo para top
	if spawned_on_top:
		current_target = bottom_target
		direction = 1
		anim.play("down_walk")
	else:
		current_target = top_target
		direction = -1
		anim.play("up_walk")

	# Se quiser inverter visual horizontalmente (não obrigatório para vertical), mantenho consistência:
	anim.flip_h = direction > 0

	# conecta detector (mesma lógica do horizontal)
	if detector and not detector.is_connected("detect", Callable(self, "_on_detect_player")):
		detector.connect("detect", Callable(self, "_on_detect_player"))


func _on_detect_player(body):
	if body.name == "Player":
		var global_player_pos = body.global_position

		# player acima e mob indo para cima (direction < 0)
		if global_player_pos.y < mob.global_position.y and direction < 0:
			print_debug("ENCONTROU O PLAYER")
			Transition.emit(self, "upattack")
			reset_counter = false

		# player abaixo e mob indo para baixo (direction > 0)
		elif global_player_pos.y > mob.global_position.y and direction > 0:
			#print_debug("ENCONTROU O PLAYER DOWN DOWN DOWN")
			#Transition.emit(self, "sideattack")
			reset_counter = false


func Physics_Update():
	# Se estiver suficientemente longe do top_target após spawn, marcamos que saiu ao menos uma vez
	if spawned_on_top and not has_top_once:
		if abs(mob.global_position.y - top_target.global_position.y) > ARRIVAL_THRESHOLD:
			has_top_once = true
			# após sair, podemos considerar chegadas futuras ao top normalmente

	var ty = current_target.global_position.y

	# Check chegada
	if abs(mob.global_position.y - ty) <= ARRIVAL_THRESHOLD:
		# Se chegou no top_target, só contamos/atuamos se já tiver saído ao menos uma vez
		if current_target == top_target:
			if spawned_on_top and not has_top_once:
				# Ignora essa chegada — é a chegada "inicial" por spawn; força a sair para bottom
				current_target = bottom_target
				direction = 1
				anim.play("down_walk")
				anim.flip_h = direction > 0
				# não incrementa counter aqui
			else:
				# chegada válida no top (após ter saído)
				current_target = bottom_target
				direction = 1
				anim.play("down_walk")
				anim.flip_h = direction > 0
				counter += 1

		# Se chegou no bottom_target, sempre troca para top (e incrementa)
		elif current_target == bottom_target:
			current_target = top_target
			direction = -1
			anim.play("up_walk")
			anim.flip_h = direction > 0
			counter += 1

	# Movimento vertical
	mob.velocity = Vector2(0, direction * SPEED)
	mob.move_and_slide()


func Update():
	# só faz a decisão se estiver no TOP TARGET e se **não** for a chegada inicial ignorada
	var on_top = abs(mob.global_position.y - top_target.global_position.y) <= ARRIVAL_THRESHOLD

	# só permite decisionstate se chegou ao top após ter saído ao menos uma vez
	if counter >= 3 and on_top and (not spawned_on_top or has_top_once):
		Transition.emit(self, "decisionstate")


func Exit():
	if reset_counter:
		counter = 1

	# desconecta detector para evitar múltiplas conexões em reentradas
	if detector and detector.is_connected("detect", Callable(self, "_on_detect_player")):
		detector.disconnect("detect", Callable(self, "_on_detect_player"))
