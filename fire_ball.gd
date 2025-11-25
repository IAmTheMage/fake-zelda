extends CharacterBody2D

var SPEED := 210.0
var move_vector := Vector2(0, 0)

func _physics_process(delta: float) -> void:
	# Se o vetor não for zero, normaliza
	if move_vector.length() > 0:
		velocity = move_vector.normalized() * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		queue_free()
