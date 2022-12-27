extends RigidBody2D
class_name Ball

onready var audio_break = get_node("_audio_break")
onready var audio_hit = get_node("_audio_hit")
onready var audio_lose = get_node("_audio_lose")
onready var audio_start = get_node("_audio_start")
onready var audio_win = get_node("_audio_win")

export var min_y_velocity: = 250
export var max_y_velocity: = 550
export var min_x_velocity: = 100
export var max_x_velocity: = 300

func _input(event):
	if not GLOBALS.game_started and event.is_action_pressed("ui_down") :
		position = Vector2(get_parent().position.x, get_parent().position.y -20)
		GLOBALS.game_started = true
		audio_start.play()
		set_as_toplevel(true)
	
func _physics_process(delta):
	if GLOBALS.game_started:
		_set_ball_velocity(linear_velocity)

	for body in get_colliding_bodies() :
		if body.is_in_group("blocks") :
			audio_break.play()

			if randi() % 2 == 1:
				_create_gift(body.position)

			body.queue_free()

			if body.get_parent().get_child_count() == 1 :
				get_tree().paused = true
				GLOBALS.game_started = false
				audio_win.play()
				yield(audio_win, "finished")
				queue_free()
				var replay_scene = load("res://src/HUD/replay.tscn")
				get_parent().add_child(replay_scene.instance())

		else :
			audio_hit.play()

func _set_ball_velocity(current_velocity: Vector2):
	var new_velocity: = current_velocity

	if abs(new_velocity.y) > max_y_velocity:
		if new_velocity.y > 0:
			new_velocity.y = max_y_velocity
		else:
			new_velocity.y = -max_y_velocity

	if abs(new_velocity.y) < min_y_velocity:
		if new_velocity.y > 0:
			new_velocity.y = min_y_velocity
		else:
			new_velocity.y = -min_y_velocity

	if abs(new_velocity.x) > max_x_velocity:
		if new_velocity.x >= 0:
			new_velocity.x = max_x_velocity
		else:
			new_velocity.x = -max_x_velocity

	if abs(new_velocity.x) < min_x_velocity:
		if new_velocity.x >= 0:
			new_velocity.x = min_x_velocity
		else:
			new_velocity.x = -min_x_velocity

	set_linear_velocity(new_velocity)

func _create_gift(gift_position: Vector2):
	var game = get_node("/root/game")
	var gift = load("res://src/gift/gift.tscn")
	var new_gift = gift.instance()
	new_gift.position = Vector2(gift_position)
	game.add_child(new_gift)

func _on__ball_screen_exited():
	get_tree().paused = true
	GLOBALS.game_started = false
	audio_lose.play()
	yield(audio_lose, "finished")
	queue_free()
	var replay_scene = load("res://src/HUD/replay.tscn")
	get_parent().add_child(replay_scene.instance())
