extends Spatial

var chunk1_scn = preload("res://Chunk1.tscn")
var score_scn = preload("res://Score.tscn")
var spawn_z = 3
var last_chunk

var score = 0

onready var chunks = $chunks
onready var score_label = $CanvasLayer/ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready():

	$AudioStreamPlayer.play()

	score = 0

	var _r = $Player.connect("player_killed", self, "_player_killed")
	var _r1 = $Player.connect("restart_requested", self, "_restart_requested")
	var _r2 = $Player.connect("player_got_coin", self, "_player_got_coin")

	for _n in range(3):
		add_chunk(0)

	for _n in range(7):
		add_chunk(1)
	

	
func chunk_removed():
	# score += 1
	add_chunk(1)

func add_chunk(obstacle_intensity):
	var inst = chunk1_scn.instance()
	inst.obstacle_intensity = obstacle_intensity
	inst.translation.z = last_chunk.translation.z - 6 if last_chunk != null else spawn_z 
	inst.connect("tree_exited", self, "chunk_removed")
	last_chunk = inst
	# chunks.add_child(inst)
	chunks.call_deferred("add_child", inst)

func _player_killed():

	for c in chunks.get_children():
		c.velocity = 0

	$AudioStreamPlayer.stop()
	$AudioStreamPlayerGameOver.play()
	
	# MyFileManager.save_new_entry('zxc', score)

	yield(get_tree().create_timer(1.5), "timeout")

	var score_inst = score_scn.instance()
	score_inst.new_score = score
	add_child(score_inst)

func _player_got_coin():
	score += 1

func _restart_requested():
	var _r = get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	score_label.text = str(score)
	pass

func _input(event):

	if event is InputEventKey and event.scancode == KEY_ESCAPE and event.pressed == false:
		get_tree().quit()
