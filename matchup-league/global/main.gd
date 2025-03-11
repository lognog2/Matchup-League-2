extends Control

var season: int
var main_node: Control
const MAX_TYPES = 5
const MIN_BASE = 500
const MAX_BASE = 10000
const MIN_MOD = 0
const MAX_MOD = 300

const SCENE_PATH = "res://scene/"
## max number of scenes that will be stored in scene history
const MAX_SCENES = 60

const DEFAULT_SERIES = "Original"

const VERSION_NUM = "2.0.1"
func commit_num() -> String: 
	return VERSION_NUM + ".8"
## returns version as int. ex: 2.0.1.8 -> 2018
func vers_as_int() -> int: 
	return int(commit_num())

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
	Freeplay = "game_select",
	GameMenu = "game_menu",
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

var GameRound = {
	Debug = -99,
	Tournament = -1,
	Freeplay = 0
}

var Entity = {
	Fighter = "fighter",
	Team = "team",
	Game = "game",
	Level = "level"
}

var Levels = {
	Prep = null,
	#"College": Level.new("College", 5),
	#"Pro": Level.new("Pro", 11),
	Archive = null
}

## names reserved for program functions
var Keyname = {
	Remove = "[Remove]",
	Bye = "[Bye]",
	ByePlain = "Bye",
	Custom = "[Custom]",
	Empty = ""
}

func _ready():
	var seed = randi()
	seed(seed)
	print("^ seed: ", seed)
	SignalBus.set_scene.connect(set_scene)
	season = 29
	Levels.Prep = Level.new("Prep", 4)
	Levels.Archive = Archive.new()
	load_state()

func _process(delta: float):
	#report lag
	if (delta > 0.0167):
		if (delta < 0.0333): print("  %.3f" %delta) # <60 fps
		elif (delta < 0.1): print ("* %.3f" %delta) # <30 fps
		else: print("! %.3f" %delta) # <10 fps

func get_level(levelName: String): return Levels[levelName]
	
func get_season(): return season

func blank_entity(ent_name: String) -> DataEntity:
	match ent_name:
		Entity.Fighter:
			return Fighter.new()
		Entity.Team:
			return Team.new()
		Entity.Game:
			return Game.new()
		_:
			Err.print_warn("%s does not match any entity name" % ent_name)
			return DataEntity.new()

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
	for level in Levels.values():
		level.load_data()
	SignalBus.done_loading.emit()
	#idc im gonna separate lib and level next update anyway
	Levels.Prep.Lib.Team.set_avg_rating()
