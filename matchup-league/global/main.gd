extends Control

var season: int
var main_node: Control
var game_seed: Variant
var current_career: Career ##set in career_select
const MAX_TYPES = 4
const MIN_BASE = 499
const MAX_BASE = 9999
const MIN_MOD = 9
const MAX_MOD = 299

const SCENE_PATH = "res://scene/%s.tscn"
## max number of scenes that will be stored in scene history
const MAX_SCENES = 8

const DEFAULT_SERIES = "Original"

const VERSION_NUM = "prototype 2.0.3"

## put in league class when i make it
const season_length = 7

func commit_version() -> String: 
	return VERSION_NUM + ".0"

var Edition = {
	Dev = "development",
	Test = "playtest",
	Prod = "Production"
}
var version_edition = commit_version() + " " + Edition.Dev

## stores previously visited scenes, behaves like a stack
var scene_history = []
var Scene = {
	TeamView = "team_view",
	Editor = "editor",
	GameSelect = "game_select",
	GameMenu = "game_menu",
	CareerSelect = "career_select",
	SeasonMenu = "season_menu",
	TeamMenu = "team_menu",
	MainMenu = "main_menu",
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
	Evil = "V",
}

## types that are out of circulation
var LegacyTypes = {
	Day = "Y",
	Night = "T",
	Series = "P",
	Default = "X"
}

## possible future types
var BetaTypes = {
	Defensive = "D",
	Natural = "N",
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
	Player = "player",
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
	Spectate = "[Spectator]",
	Empty = ""
}

func _ready():
	game_seed = randi()
	seed(game_seed)
	print("^ seed: ", game_seed)
	SignalBus.set_scene.connect(set_scene)
	season = 29
	Levels.Prep = Level.new("Prep", 3, 4)
	Levels.Archive = Archive.new()
	load_state()

func _process(delta: float):
	#report lag
	if (delta > 0.0167):
		if (delta < 0.0333): print("  %.3f" %delta) # <60 fps
		elif (delta < 0.1): print ("* %.3f" %delta) # <30 fps
		else: print("! %.3f" %delta) # <10 fps
	
	# idk why i did this
	var ticket = randi()
	if (ticket == game_seed): Err.alert_warn("JACKPOT!!!", 777)
	if (ticket % 1_000_000 == 0): 
		print("$ ", ticket)
		Err.alert_success("you're one in a million!", 777)

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
		Entity.Player:
			return Player.new()
		_:
			Err.alert_warn("Main.blank_entity: %s does not match any entity name" % ent_name, Err.Warn.Invalid)
			return DataEntity.new()

# scene functions

## sets scene to `sc` scene. if `sc` is empty, goes back a scene
func set_scene(sc: String):
	if (sc == scene_history.back()): return
	if (sc):
		scene_history.append(sc)
		var new_scene = load(SCENE_PATH % sc)
		main_node.set_scene(new_scene.instantiate(), sc)
		if (scene_history.size() > MAX_SCENES): scene_history.pop_front()
	elif(scene_history.size() > 1):
		scene_history.pop_back()
		emit_scene(scene_history.pop_back())
	else:
		Err.print_warn("ran out of scenes to go back to :/", Err.Warn.NoAction)
	
func emit_scene(sc: String = ""):
	SignalBus.set_scene.emit(sc)

func validate_name(n: String) -> bool:
	return !Keyname.values().has(n)

# save/load functions

func save_state(softSave = true):
	print("^ saving")
	main_node.save_game_start()
	for level in Levels:
		Levels[level].save_data(softSave)
	main_node.save_game_end()
	#Err.alert_success("saved successfully", Err.Success.Success)
	#SignalBus.done_saving.emit()
	print("^ saved")

func load_state():
	print("^ loading")
	for level in Levels.values():
		level.load_data()
	print("^ loaded")
	SignalBus.done_loading.emit()
	Levels.Prep.Lib.Team.set_avg_rating()
