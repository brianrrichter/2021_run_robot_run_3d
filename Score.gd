extends MarginContainer

var new_score

onready var bt_voltar = $VBoxContainer/CenterContainer/VoltarButton
onready var new_entry_lineedit #= $VBoxContainer/NewEntryLineEdit
onready var scrollable_vbox = $VBoxContainer/ScrollContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	bt_voltar.connect("pressed", self, "_voltar_pressed")

	# new_entry_lineedit.connect("text_changed", self, "_new_entry_text_changed")

	$VBoxContainer/RichTextLabel.clear()

	# var d = MyFileManager.load_config()
	
	# var text = ""
	
	# var keys = d.keys()
	# keys.sort()
	
	# for key in keys:
	# 	text += str("\n", "%.1f" % key, ": ", d[key])

	_update_list()

func _new_entry_text_changed(text):

	print("_new_entry_text_changed: ", text)
	
	var t = text.to_upper()
	new_entry_lineedit.text = t
	new_entry_lineedit.set_cursor_position(t.length())

	if t.length() >= 3 and new_score != null:
		MyFileManager.save_new_entry(t.left(3), new_score)
		new_entry_lineedit.hide()
		_update_list()

func _voltar_pressed():
	# var _r = get_tree().change_scene("res://MainMenu.tscn")
	Global.goto_scene("res://MainMenu.tscn")

func _create_new_score_lineedit():
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://fonts/m3x6.ttf")
	dynamic_font.size = 56

	new_entry_lineedit = LineEdit.new()
	new_entry_lineedit.set("custom_fonts/font", dynamic_font)
	new_entry_lineedit.cursor_set_blink_enabled(true)
	new_entry_lineedit.connect("text_changed", self, "_new_entry_text_changed")
	return new_entry_lineedit

func _update_list():
	var score_list = MyFileManager.load_score_list()
	
	for child in scrollable_vbox.get_children():
		child.queue_free()

	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://fonts/m3x6.ttf")
	dynamic_font.size = 56

	var previous_score : int = 10000

	var position : int = 0

	var new_lineedit = null

	# var text = ""
	for entry in score_list:
		# text += str("\n%s - %04d" % [entry.name, entry.score])

		if previous_score > entry.score:
			position += 1

		if new_score != null && new_entry_lineedit == null and new_score > entry.score:
			new_lineedit = _create_new_score_lineedit()
			scrollable_vbox.add_child(new_lineedit)
		
		var label = Label.new()
		label.set("custom_fonts/font", dynamic_font)
		label.text = (str("\n %03d - %s - %04d" % [position, entry.name, entry.score]))
		scrollable_vbox.add_child(label)
		
		previous_score = entry.score
		# new_entry_lineedit.setcurrent

	# garantir que se for o menor score, o campo seja exibido
	if new_score != null && new_entry_lineedit == null:
		new_lineedit = _create_new_score_lineedit()
		scrollable_vbox.add_child(new_lineedit)

	if new_lineedit != null:
		new_lineedit.grab_focus()
		yield(get_tree(), "idle_frame")
		$VBoxContainer/ScrollContainer.ensure_control_visible(new_lineedit)
	
	# $VBoxContainer/RichTextLabel.text = str(text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
