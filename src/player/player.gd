extends KinematicBody2D
class_name Player

onready var sprite = $_sprite
onready var colission = $_colission
onready var gift_audio = $gift_audio
onready var powerup_timer = $powerup_timer

var movement = Vector2()

export var speed = 4
export var lifes = 3

var jumps = 0
var jump_status = false
var jump_height = 32
var jump_duration = 0.25
var jump_velocity = jump_height * jump_duration

var gravity_status = false
var gravity = 2

#Acciones que se ejecutan al instanciar el objeto
func _ready():
	GLOBALS.connect("gift_picked", self, "_on__gift_gift_picked")

#Usar _input cuando el evento es disparado por única vez
#func _input(event):

#Acciones que se ejecutan en cada frame
func _physics_process(delta) :
	if position.y == 470:
		gravity_status = false
		#jumps = 0

	if gravity_status:
		_apply_gravity()

	if Input.is_action_pressed("ui_left") :
		_move_left()

	if Input.is_action_pressed("ui_right") :
		_move_right()

	if GLOBALS.game_started and jumps == 0 and Input.is_action_pressed("ui_up") :
		jump_status = true
		gravity_status = true
		_jump()

func _on__gift_gift_picked():
	_enable_powerup()

func _on_powerup_timer_timeout():
	_disable_powerup()

func _move_left():
	var move = Vector2(-speed, 0)
	move_and_collide(move)

func _move_right():
	var move = Vector2(speed, 0)
	move_and_collide(move)

func _jump():
	if position.y <= 470 - jump_height:
		jump_status = false
		jumps += 1

	if jump_status:
		var move = Vector2(0, -jump_velocity)
		move_and_collide(move)

func _apply_gravity():
	var gravity_move = Vector2(0, +gravity)
	move_and_collide(gravity_move)

func _enable_powerup():
	powerup_timer.start(rand_range(3, 6))
	sprite.frame = 1
	colission.shape.height = 76
	gift_audio.play()

func _disable_powerup():
	sprite.frame = 0
	colission.shape.height = 44
