extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func collected():
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("collected")
	
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(5 * delta)
