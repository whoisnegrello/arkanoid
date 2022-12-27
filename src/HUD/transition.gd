extends CanvasLayer

onready var animation_player = $_animation

func change_scene_transition(path):
	layer = 1
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	get_tree().change_scene(path)
	animation_player.play_backwards("fade")
	yield(animation_player, "animation_finished")	
	layer = -1

func _ready():
	layer = -1
