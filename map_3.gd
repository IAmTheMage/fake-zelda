extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func get_mob_nodes(node: Node) -> int:
	var result: int = 0
	for child in node.get_children():
		if "Mob" in child.name:
			result += 1
	
	return result
	
func _get_mob_nodes(node: Node) -> Array:
	var result: Array = []
	for child in node.get_children():
		if "Mob" in child.name:
			result.append(child)
		result += _get_mob_nodes(child)
	return result

func kill_random_mob():
	var mobs = _get_mob_nodes(get_tree().get_current_scene())

	if mobs.is_empty():
		print("Nenhum Mob encontrado")
		return

	var random_mob = mobs[randi() % mobs.size()]
	random_mob.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var num_mobs = get_mob_nodes(get_tree().get_current_scene())
	if num_mobs == 0:
		$Door.allowed_to_pass = true
		
	if Input.is_action_just_pressed("ui_accept"): # ESPAÇO padrão da Godot
		kill_random_mob()
