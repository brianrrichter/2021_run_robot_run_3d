extends Spatial


enum Status {
	RUNNING,
	DECEASED
}

var state_machine

var is_jumping = false
var is_on_floor = true

var velocity = 2
var status = Status.RUNNING

var _Y = 1
var GRAVITY = 11
var MAX_JUMP_HEIGHT = 2

# onready var bt_left = $Ui/LeftButton
# onready var bt_right = $Ui/RightButton
onready var bt_restart = $Ui/RestartButton
onready var bt_voltar = $Ui/VoltarButton
onready var bt_sound = $Ui/SoundTextureButton

# var dir : int = 0

signal player_killed()
signal player_got_coin()
signal restart_requested()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Robot/AnimationTree.active = true
	state_machine = $Robot/AnimationTree.get("parameters/playback")

	# _play_animation($Robot/AnimationPlayer, "Robot_Running")

	bt_sound.pressed = AudioServer.is_bus_mute(0)

	var _r = $Area.connect("area_entered", self, "_area_entered")

	var _r2 = bt_restart.connect("pressed", self, "_restart_requested")

	var _r3 = bt_voltar.connect("pressed", self, "_voltar_pressed")

	var _r4 = bt_sound.connect("toggled", self, "_sound_toggled")

# func _unhandled_input(event):
# 	if event.is_action_pressed("ui_left"):
# 		dir -= 1
# 	if event.is_action_pressed("ui_right"):
# 		dir += 1

# 	dir = clamp(dir, -1, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if status == Status.RUNNING:
		if is_on_floor:
			var dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			translation.x = lerp(translation.x, dir * velocity, .1)

		if Input.is_action_just_pressed("ui_accept") and is_on_floor:
			# _play_animation($Robot/AnimationPlayer, "Robot_WalkJump")
			state_machine.travel("Robot_WalkJump")
			is_jumping = true
			is_on_floor = false
		
		if is_jumping and translation.y < MAX_JUMP_HEIGHT:
			translation.y = translation.y + (max(MAX_JUMP_HEIGHT - translation.y, .05)) * GRAVITY * delta
		elif is_jumping == true:
			is_jumping = false
			
		

		if !is_jumping and translation.y > _Y:
			translation.y = max(_Y, translation.y - (max(MAX_JUMP_HEIGHT - translation.y, .05)) * GRAVITY * delta)
		elif !is_on_floor and translation.y <= _Y:
			is_on_floor = true

		# var dir = 0
		# if Input.is_key_pressed(KEY_A) or bt_right.pressed:
		# 	dir = -1
		# elif  Input.is_key_pressed(KEY_D):
		# 	dir = 1

		# if dir != 0:
		# 	translation.x = clamp(translation.x + velocity * delta * dir, -2, 2)
		# else:
		# 	translation.x = translation.x - velocity * translation.x * delta

		# translation.x = dir * velocity

		


func _play_animation(anim_player, animation_name, loop = true):
	var animation = anim_player.get_animation(animation_name)
	animation.set_loop(loop)
	
	# $Spatial/Bull2/AnimationPlayer.play(animation_name)
	anim_player.play(animation_name)

func _area_entered(area):
	if area.is_in_group("harm"):
		velocity = 0
		_play_animation($Robot/AnimationPlayer, "Robot_No")
		status = Status.DECEASED
		$Ui.hide()
		emit_signal("player_killed")
	elif area.is_in_group("coin"):
		emit_signal("player_got_coin")
		area.get_parent().collected()

func _restart_requested():
	emit_signal("restart_requested")

func _voltar_pressed():
	# var _r = get_tree().change_scene("res://MainMenu.tscn")
	Global.goto_scene("res://MainMenu.tscn")

func _sound_toggled(button_pressed):
	AudioServer.set_bus_mute(0, button_pressed)