extends CharacterBody2D

const SPEED = 300.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_area: Area2D = $DmgCollision;

signal TakeDamage;

func _ready() -> void:
	collision_area.connect("area_entered", take_damage)

func find_first_damage_obj(node: Node) -> DamageObj:
	if node is DamageObj:
		return node

	for child in node.get_children():
		var result = find_first_damage_obj(child)
		if result:
			return result

	return null


func take_damage(body) -> void:
	print_debug(body)
	var owner = body.get_owner()
	if owner == null:
		return

	var damage_obj = find_first_damage_obj(owner)
	if damage_obj:
		TakeDamage.emit(damage_obj.damage)
	else:
		print_debug(owner)
		
func _physics_process(delta: float) -> void:
	var x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Priorizar apenas um eixo (bloquear diagonal)
	if abs(x) > 0 and abs(y) > 0:
		if abs(x) > abs(y):
			y = 0
		else:
			x = 0

	velocity = Vector2(x, y) * SPEED

	# Animações / flip apenas do nó visual
	if velocity.x != 0:
		# Só chama play se não estiver já tocando "side_walk"
		if anim.animation != "side_walk":
			anim.play("side_walk")
		# percorre para a esquerda quando flip_h = true
		anim.flip_h = velocity.x < 0
	elif velocity.y != 0:
		# Exemplo: tocar animação vertical (mude os nomes conforme seu setup)
		if velocity.y < 0:
			if anim.animation != "back_walk":
				anim.play("back_walk")
		else:
			if anim.animation != "front_walk":
				anim.play("front_walk")
		# não invertemos horizontalmente quando anda vertical
		anim.flip_h = false
	else:
		# parado: animação de idle (ou stop)
		if anim.animation == "front_walk":
			anim.play("front_idle")
			
		elif anim.animation == "back_walk":
			anim.play("back_idle")
			
		elif anim.animation == "side_walk":
			anim.play("side_idle")

	move_and_slide()
