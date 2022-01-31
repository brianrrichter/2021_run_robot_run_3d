extends KinematicBody


var gravity = Vector3.DOWN * 10

var velocity = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	_play_animation($Donkey/AnimationPlayer, "Idle")


func _physics_process(delta):
	velocity += gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)

func _play_animation(anim_player, animation_name):
	var animation = anim_player.get_animation(animation_name)
	animation.set_loop(true)
	
	# $Spatial/Bull2/AnimationPlayer.play(animation_name)
	anim_player.play(animation_name)