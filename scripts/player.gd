extends CharacterBody2D

const SPEED := 300.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_area: Area2D = $DmgCollision
@onready var attack_area: Area2D = $Attack
@onready var attack_timer: Timer = $Attack/AttackTimer
@onready var cooldown_timer: Timer = $Attack/CooldownTimer

var CAN_ATTACK := true
var IS_ATTACKING := false

signal TakeDamage

func _ready() -> void:
	collision_area.connect("area_entered", take_damage)


# ------------------------------
# DAMAGE HANDLE
# ------------------------------
func find_first_damage_obj(node: Node) -> DamageObj:
	if node is DamageObj:
		return node

	for child in node.get_children():
		var result = find_first_damage_obj(child)
		if result:
			return result

	return null


func take_damage(body) -> void:
	var body_owner = body.get_owner()
	if body_owner == null:
		return

	var damage_obj = find_first_damage_obj(body_owner)
	if damage_obj:
		TakeDamage.emit(damage_obj.damage)


# ------------------------------
# MOVEMENT
# ------------------------------
func _physics_process(_delta: float) -> void:
	var x := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y := Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# No diagonal movement
	if abs(x) > 0 and abs(y) > 0:
		if abs(x) > abs(y): y = 0
		else: x = 0

	velocity = Vector2(x, y) * SPEED

	# ATTACK PRESS
	if Input.is_action_just_pressed("ui_accept") and CAN_ATTACK and not IS_ATTACKING:
		var dir := get_attack_direction()
		attack(dir)

	# Animation movement
	if velocity.x != 0:
		if anim.animation != "side_walk":
			anim.play("side_walk")
		anim.flip_h = velocity.x < 0
	
	elif velocity.y != 0:
		if velocity.y < 0:
			if anim.animation != "back_walk":
				anim.play("back_walk")
		else:
			if anim.animation != "front_walk":
				anim.play("front_walk")
		anim.flip_h = false

	else:
		match anim.animation:
			"front_walk": anim.play("front_idle")
			"back_walk": anim.play("back_idle")
			"side_walk": anim.play("side_idle")

	move_and_slide()


# ------------------------------
# ATTACK LOGIC
# ------------------------------
func get_attack_direction() -> String:
	if anim.animation.begins_with("side"):
		return "left" if anim.flip_h else "right"
	if anim.animation.begins_with("front"):
		return "down"
	if anim.animation.begins_with("back"):
		return "up"
	return "right"


func attack(direction: String) -> void:
	#IS_ATTACKING = true
	#CAN_ATTACK = false

	attack_area.monitoring = false
	attack_area.monitoring = true
	attack_area.visible = true

	match direction:
		"right": attack_area.rotation_degrees = 0
		"left": attack_area.rotation_degrees = 180
		"up": attack_area.rotation_degrees = -90
		"down": attack_area.rotation_degrees = 90

	attack_timer.start() 


func _on_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.Health.take_damage(1)
		print("damaging mob")


# ------------------------------
# TIMERS
# ------------------------------
func _on_attack_timer_timeout() -> void:
	# attack animation finished
	attack_area.visible = false
	attack_area.monitoring = false


func _on_cooldown_timer_timeout() -> void:
	CAN_ATTACK = true
	IS_ATTACKING = false
	print("test")
