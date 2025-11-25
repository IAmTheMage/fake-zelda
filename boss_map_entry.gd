extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Boss/AnimatedSprite2D.connect("animation_finished", Callable(self, "go_to_boss_map"))

func go_to_boss_map():
	get_tree().change_scene_to_file("res://boss_map.tscn")
