extends Control


onready var bt_play = $VBoxContainer/HBoxContainer/PlayButton
onready var bt_leader_board = $VBoxContainer/HBoxContainer/LeaderBoardButton
onready var bt_exit = $VBoxContainer/HBoxContainer/ExitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	var _r1 = bt_play.connect("pressed", self, "_start_game")
	var _r2 = bt_leader_board.connect("pressed", self, "_show_leader_board")
	var _r3 = bt_exit.connect("pressed", self, "_exit_game")

	AudioServer.set_bus_mute(0, true)

func _start_game():
	var _r = get_tree().change_scene("res://Level3.tscn")

func _show_leader_board():
	var _r = get_tree().change_scene("res://Score.tscn")

func _exit_game():
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
