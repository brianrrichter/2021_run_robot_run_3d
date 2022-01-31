extends Spatial

var obs_barrel_scn = preload("res://obstacles/ObstacleBarrel.tscn")
var obs_short_scn = preload("res://obstacles/ObstacleShort.tscn")
var coin_scn = preload("res://obstacles/Coin.tscn")

var pos
var velocity = 8
var _Y = 1.5
var _x_arr = [-2,0,2]
var obstacle_intensity = 0
var off_screen_remove_distance = 10

# Called when the node enters the scene tree for the first time.
func _ready():

	if obstacle_intensity > 0:
		var i = randi() % 6
		if i < 3:
			_instance_obstacle(obs_barrel_scn, i)
			_instance_obstacle(coin_scn, (i + 1) % 3)
			_instance_obstacle(obs_short_scn, (i + 2) % 3)

func _instance_obstacle(scn, pos_index):
	var inst = scn.instance()
	inst.translation.y = _Y
	inst.translation.x = _x_arr[pos_index]
	add_child(inst)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# pos = translation
	# pos.z += velocity
	
	if velocity > 0:
		translation.z += velocity * delta

	if translation.z > off_screen_remove_distance:
		queue_free()
