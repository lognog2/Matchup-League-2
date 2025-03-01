extends Control

var season: int

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
var version = VERSION_NUM + Edition.Dev

var scene_arr = []
var Scene = {
	MainMenu = "main_menu",
	TeamView = "team_view",
	Editor = "editor",
	Freeplay = "game_select"
}

var Types = {
	0: "M",
	1: "R",
	2: "E",
	3: "F",
	4: "W",
	5: "L",
	6: "A",
	7: "G",
	8: "C",
	9: "I",
	10: "S",
	11: "V"
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
	Empty = ""
}

func _ready():
	SignalBus.set_scene.connect(set_scene)
	get_children().clear()
	set_scene(Scene.MainMenu)
	season = 29
	load_state()

func _process(delta: float):
	#report lag
	if (delta > 0.0167):
		if (delta < 0.0333): print("  ", delta) # <60 fps
		elif (delta < 0.1): print ("* ", delta) # <30 fps
		else: print("! ", delta) # <10 fps

func get_level(levelName): return Levels[levelName]
	
func get_season(): return season


# scene functions

func set_scene(sc: String):
	if (sc):
		scene_arr.append(sc)
		var new_scene = load(SCENE_PATH + sc + ".tscn")
		add_child(new_scene.instantiate())
		if (get_child_count() > 1): get_child(-2).visible = false
	elif(scene_arr.size() > 1):
		scene_arr.pop_back()
		get_child(-1).queue_free()
		get_child(-1).visible = true
	
func emit_scene(sc: String = ""):
	SignalBus.set_scene.emit(sc)

func validate_name(n: String) -> bool:
	return Main.Keyname.values().has(n)


# save/load functions

func save_state(softSave = true):
	print("^ saving")
	for level in Levels:
		Levels[level].save_data(softSave)
	print("^ saved")

func load_state():
	Levels["Prep"].load_data()
	SignalBus.done_loading.emit()