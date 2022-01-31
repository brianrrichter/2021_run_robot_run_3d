extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func save_config(d):
	print("saving config - init")
	
#	var d = {}
#	d[1.0] = "Mary"
#	d[1.5] = "John"
	
	var path = "user://config.ini"
	var config = ConfigFile.new()
	var _err0 = config.load(path)
	config.set_value("best_score", "list", d)
	

	var array = config.get_value("score", "list", [])
	var entry = {}
	# entry['date'] = "{year}-{month}-{day} {hour}:{minute}:{second}".format(OS.get_datetime())

	var date = OS.get_datetime()
	entry['date'] = "%s-%02d-%02d %02d:%02d:%02d" % [date.year, date.month, date.day, date.hour, date.minute, date.second]

	entry['score'] = 11
	entry['name'] = 'zzz'
	array.append(entry)

	config.set_value("score", "list", array)

	var err = config.save(path)
	
	if err != OK:
		print("error on save config")
	
	print("saving config - end")

func save_new_entry(name, score):
	print("saving config - init")
	
#	var d = {}
#	d[1.0] = "Mary"
#	d[1.5] = "John"
	
	var path = "user://config.ini"
	var config : ConfigFile = ConfigFile.new()
	var _err0 = config.load(path)
	# config.set_value("best_score", "list", d)

	var array = config.get_value("score", "list", [])
	var entry = {}
	# entry['date'] = "{year}-{month}-{day} {hour}:{minute}:{second}".format(OS.get_datetime())

	var date = OS.get_datetime()
	entry['date'] = "%s-%02d-%02d %02d:%02d:%02d" % [date.year, date.month, date.day, date.hour, date.minute, date.second]

	entry['score'] = score
	entry['name'] = name
	array.append(entry)

	config.set_value("score", "list", array)

	var err = config.save(path)
	
	if err != OK:
		print("error on save config")
	
	print("saving new entry config - end")

func load_config():
	var path = "user://config.ini"
	var config = ConfigFile.new()
	
	var err = config.load(path)
	
	if err != OK:
		print("error on loading config")
	
	var d = {}
	
	return config.get_value("best_score", "list", d)
	
func load_score_list():
	var path = "user://config.ini"
	var config = ConfigFile.new()
	
	var err = config.load(path)
	
	if err != OK:
		print("error on loading config")
	
	var d = []
	
	d = config.get_value("score", "list", d)

	d.sort_custom(ScoreSorter, "sort_descending")

	return d

func verify_new_score(time):
	var d = load_config()
	
	var keys = d.keys()
	

	
	var MAX_ITEMS = 10
	
	if keys.empty() or keys.max() > time or keys.size() < MAX_ITEMS:
		if keys.size() >= MAX_ITEMS:
			d.erase(keys.max())
		
		
		d[time] = "name"
	
	save_config(d)

func clear_score():
	var d = {}
	
	save_config(d)

class ScoreSorter:
	static func sort_descending(a, b):
		if a.score > b.score:
			return true
		return false