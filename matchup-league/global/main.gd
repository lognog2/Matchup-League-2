extends Control

var season: int
var main_node: Control
const MAX_TYPES = 5
const MIN_BASE = 500
const MAX_BASE = 10000
const MIN_MOD = 0
const MAX_MOD = 300

const SCENE_PATH = "res://scene/"
const MAX_SCENES = 3

const VERSION_NUM = "2.0.1"
var Edition = {
	Dev = "Development",
	Test = "Playtest",
	Prod = ""
}
var version = VERSION_NUM + " " + Edition.Dev

var scene_arr = []
var Scene = {
	MainMenu = "main_menu",
	TeamView = "team_view",
	Editor = "editor",
	Freeplay = "game_select"
}

var Types = {
	Melee = "M",
	Ranged = "R", 
	Explosive = "E", 
	Fire = "F", 
	Water = "W", 
	Electric = "L",
	Aerial = "A",
	Magic = "G",
	Mechanical = "C",
	Ice = "I",
	Star = "S",
	Evil = "V"
}

## types that are out of circulation
var LegacyTypes = {
	Day = "D",
	Night = "N",
	Series = "P"
}

var Levels = {
	"Prep": Level.new("Prep", 4),
	#"College": Level.new("College", 5),
	#"Pro": Level.new("Pro", 11),
	#"Archive": Level.new("Archive")
}

## names reserved for program functions
var Keyname = {
	Remove = "[Remove]",
	Bye = "[Bye]",
	ByePlain = "Bye",
	Empty = ""
}

func _ready():
	SignalBus.set_scene.connect(set_scene)
	season = 29
	load_state()

func _process(delta: float):
	#report lag
	if (delta > 0.0167):
		if (delta < 0.0333): print("  %.3f" %delta) # <60 fps
		elif (delta < 0.1): print ("* %.3f" %delta) # <30 fps
		else: print("! %.3f" %delta) # <10 fps

func get_level(levelName): return Levels[levelName]
	
func get_season(): return season

#convenience functions

## calls `queue_free()` on each child of this node
func remove_children(node: Node):
	for child in node.get_children():
		child.queue_free()

# scene functions

func set_scene(sc: String):
	if (sc):
		scene_arr.append(sc)
		var new_scene = load(SCENE_PATH + sc + ".tscn")
		main_node.add_child(new_scene.instantiate())
		if (get_child_count() > 1): get_child(-2).visible = false
	elif(scene_arr.size() > 1):
		scene_arr.pop_back()
		main_node.get_child(-1).queue_free()
		main_node.get_child(-1).visible = true
	
func emit_scene(sc: String = ""):
	SignalBus.set_scene.emit(sc)

func validate_name(n: String) -> bool:
	return !Main.Keyname.values().has(n)

# save/load functions

func save_state(softSave = true):
	print("^ saving")
	for level in Levels:
		Levels[level].save_data(softSave)
	print("^ saved")

func load_state():
	Levels["Prep"].load_data()
	SignalBus.done_loading.emit()
