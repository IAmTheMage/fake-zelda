extends Node2D

@export var next_scene: PackedScene;
@export var collisions: Node2D;
var allowed_to_pass = false;
var already_destroyed_door = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DoorsSprite.sprite_frames.set_animation_loop("default", false)
	$DoorsSprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if allowed_to_pass == true and already_destroyed_door == false:
		$DoorsSprite.sprite_frames.set_animation_loop("opened", false)
		$DoorsSprite.play("opened")
		collisions.queue_free()
		already_destroyed_door = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_packed(next_scene)
