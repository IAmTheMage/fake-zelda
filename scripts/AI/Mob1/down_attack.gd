extends State
class_name Mob1DownAttack

@export var anim: AnimatedSprite2D
@export var detector: Area2D
@export var timer: Timer

@export var ArrowScene: PackedScene
@export var Mob: CharacterBody2D
@export var UpSpawner: Area2D    # UpAttackSpawner, posicionado acima do mob


func Enter():
	anim.play("down_attack")
	# garante que a animação não fique em loop automático
	anim.sprite_frames.set_animation_loop("down_attack", false)
	timer.wait_time = 1.0
	if not timer.is_connected("timeout", Callable(self, "_on_down_attack_timer_timeout")):
		timer.connect("timeout", Callable(self, "_on_down_attack_timer_timeout"))
	# conectar para detectar quando o player sai da área (mesma lógica do side)
	if not detector.is_connected("body_exited", Callable(self, "exit_area")):
		detector.connect("body_exited", Callable(self, "exit_area"))
	shoot()


func exit_area(body):
	if body.name == "Player":
		if anim.animation == "down_attack":
			print_debug("Saindo da area dogao")
			anim.pause()
			timer.stop()
			# volta para o estado de idle vertical (ajuste o nome do estado se você usar outro)
			Transition.emit(self, "mob1updownwalking")


func shoot():
	var proj = ArrowScene.instantiate()
	# escala reduzida igual ao side
	proj.scale = Vector2.ONE * 0.25
	# dispara a partir do spawner de cima
	proj.global_position = UpSpawner.global_position

	# define direção para cima (assumindo que seu projectile aceita Vector2)
	# se o seu Arrow usar outro formato (ex: direction = -1 ou direction_y), adapte aqui.
	proj.xy_v = Vector2(0, -1)

	get_tree().current_scene.add_child(proj)


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "down_attack":
		anim.pause()
	timer.start()
	


func _on_down_attack_timer_timeout() -> void:
	if anim.animation == "down_attack":
		anim.play("down_attack")
	shoot()

func Exit():
	timer.disconnect("timeout", Callable(self, "_on_down_attack_timer_timeout"))
