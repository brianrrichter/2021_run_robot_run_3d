extends Spatial

var _Y = 0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# _play_animation($Spatial/Bull2/AnimationPlayer, "Idle")
	# # _play_animation($Anglerfish/AnimationPlayer, "Swimming_Fast")
	# _play_animation($Alpaca/AnimationPlayer, "Eating")

	_play_animation($Robot/AnimationPlayer, "Robot_Idle")

	$StaticBody.connect("input_event", self, "_on_StaticBody_input_event")

	$Anglerfish.connect("goal_position_achieved", self, "_on_goal_position_achieved")

#	var animation = $Bull2/AnimationPlayer.get_animation("Walk")
#	animation.set_loop(true)
#
#	$Bull2/AnimationPlayer.play("Walk")
#	$Bull2/AnimationPlayer.play("Attack_Headbutt")
	

func _play_animation(anim_player, animation_name):
	var animation = anim_player.get_animation(animation_name)
	animation.set_loop(true)
	
	# $Spatial/Bull2/AnimationPlayer.play(animation_name)
	anim_player.play(animation_name)


func _on_StaticBody_input_event(_camera, event, click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		$Alpaca.transform.origin = click_position
		$Anglerfish.path.append(Vector3(click_position.x,0,click_position.z))
		# $Player.target = click_position

func _on_goal_position_achieved():
	var random_pos = _get_random_position()
	# $Donkey.transform.origin = random_pos
	$Anglerfish.path.append(random_pos)

func _get_random_position():
	return Vector3(rng.randf_range(-32, 32), _Y, rng.randf_range(-32, 32))

func _input(event):

	if event is InputEventKey and event.scancode == KEY_ESCAPE and event.pressed == false:
		get_tree().quit()
