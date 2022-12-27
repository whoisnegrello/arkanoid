extends RigidBody2D
class_name Gift

onready var sprite = $_sprite

func _ready():
	var gift_position = randi() % 6
	sprite.frame = gift_position

func _on__gift_screen_exited():
	queue_free()


func _on_gift_body_entered(body):
	if body is Player:
		GLOBALS.emit_signal("gift_picked")
		queue_free()
