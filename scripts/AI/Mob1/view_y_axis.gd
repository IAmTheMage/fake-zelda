extends Area2D

signal detect(target)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))



func _on_body_entered(body):
	emit_signal("detect", body)
