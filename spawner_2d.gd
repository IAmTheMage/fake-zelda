extends Node2D
class_name Spawn;

@export var spawn_obj: PackedScene;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var obj = spawn_obj.instantiate()
	obj.global_position = global_position
	
	get_tree().current_scene.add_child.call_deferred(obj)
