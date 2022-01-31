extends KinematicBody

const UNIT_SIZE = 1
var run_speed = 4 * UNIT_SIZE

var velocity = Vector3()
var path = []
var curr_goal_index = 1

var _Y = 0

onready var _spatial = $Anglerfish

signal goal_position_achieved

# Called when the node enters the scene tree for the first time.
func _ready():
	_play_animation($Anglerfish/AnimationPlayer, "Swimming_Fast")
	# global_transform.origin
	path.append(translation)
	path.append(Vector3(10,_Y,10))
	# path.append(Vector3(10,_Y,0))
	# path.append(Vector3(0,_Y,10))

func _play_animation(anim_player, animation_name):
	var animation = anim_player.get_animation(animation_name)
	animation.set_loop(true)
	
	# $Spatial/Bull2/AnimationPlayer.play(animation_name)
	anim_player.play(animation_name)

func _physics_process(_delta):
	if path.empty():
		return

	var curr_goal_distance = translation.distance_to(path[curr_goal_index])

	if curr_goal_distance < 3:
		if path.size() -1 > curr_goal_index:
			curr_goal_index = curr_goal_index + 1
		else:
			path.clear()
			curr_goal_index = 0
			emit_signal("goal_position_achieved")
			return

	
	
	# _spatial.look_at(path[curr_goal_index], Vector3.UP)

	var direction = (path[curr_goal_index] - Vector3(translation.x, _Y, translation.z)).normalized()
	
#	var direction = curr_level.get_path_direction(position)
	
	# var ang = lerp(_animatedSprite.get_rotation(), direction.angle(), .09)
	
	# _animatedSprite.set_rotation(ang)
	# _collisionShape2D.set_rotation(ang)

#	rotates helth bar as well, wich is not intended
#	set_rotation(direction.angle())
	
	velocity = lerp(velocity, direction * run_speed, .1)
	
	velocity = move_and_slide(velocity, Vector3.UP)

	var angle = atan2(direction.x, direction.z)
	var char_rot = _spatial.rotation
	char_rot.y = lerp_angle(char_rot.y, angle, .07)
	_spatial.set_rotation(char_rot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
