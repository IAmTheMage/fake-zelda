extends Node

@export var life: int = 3
@onready var cooldown_timer: Timer = $DamageCooldownTimer

var can_take_damage: bool = true


func take_damage(damage: int) -> void:
	print_debug(life)
	if not can_take_damage:
		return

	life -= damage
	can_take_damage = false
	cooldown_timer.start()

	if life <= 0:
		die()


func die() -> void:
	get_parent().queue_free()


func _on_damage_cooldown_timer_timeout() -> void:
	print_debug("terminou")
	can_take_damage = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		take_damage(1)
