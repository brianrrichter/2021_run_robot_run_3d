extends Node

# background loading:
# https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html

var loader
var wait_frames
var time_max = 100
var current_scene

onready var loading_label = $loadingLabel


func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func goto_scene(path):
	loading_label.show()

	loader = ResourceLoader.load_interactive(path)
	if loader == null:
		# show_error()
		return
	set_process(true)

	current_scene.queue_free()

	# get_node("animation").play("loading")

	wait_frames = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			loading_label.hide()
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # Error during loading.
			# show_error()
			loader = null
			break

func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()

	# get_node("progress").set_progress(progress)
	loading_label.text = str(progress, " / ", loader.get_stage_count())


func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
