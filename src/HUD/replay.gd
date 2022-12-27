extends Node

func _on__start_button_pressed():
	get_tree().paused = false
	#get_tree().change_scene("res://src/HUD/game.tscn")
	TRANSITION.change_scene_transition("res://src/HUD/game.tscn")

func _on__quit_button_pressed():
	get_tree().quit()
