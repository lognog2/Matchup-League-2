extends Node

var season: int
var main_node: Control
var game_seed: Variant
var current_career: Career
var backup = true
const MAX_TYPES = 4
const MIN_BASE = 499
const MAX_BASE = 9999
const MIN_MOD = 9
const MAX_MOD = 299
const CANON_SEED = 1
const SCENE_PATH = "res://scene/%s.tscn"
## max number of scenes that will be stored in scene history
const MAX_SCENES = 8

const DEFAULT_SERIES = "Original"

const VERSION_NUM = "prototype 2.0.3"

## put in league class when i make it
const season_length = 7

func commit_version() -> String: 
	return VERSION_NUM + ""

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
	LoadCareer = "load_career",
	CareerSelect = "career_select",
	SeasonMenu = "season_menu",
	TeamMenu = "team_menu",
	MainMenu = "main_menu",
	SettingsMenu = "settings_menu",
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
	Stream.queue(func(): set_seed(randi()))
	SignalBus.set_scene.connect(set_scene)
	season = 29
	Levels.Prep = Level.new("Prep", 3, 4)
	Levels.Archive = Archive.new()
	load_state()

func _process(delta: float):
	#report lag
	if (delta > 0.0167):
		if (delta < 0.0333): pass #Err.print("  %.3f" % delta) # <60 fps
		elif (delta < 0.1): Err.print("* %.3f" %delta) # <30 fps
		else: Err.print("! %.3f" %delta) # <10 fps
	
	# idk why i did this
	var ticket = randi()
	if (ticket == game_seed): Err.alert_warn("JACKPOT!!!", 777)
	if (ticket % 1_000_000 == 0): 
		Err.print("$ " + ticket)
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
	
func set_seed(new_seed: int):
	game_seed = new_seed
	seed(game_seed)
	main_node.seed_label.text = "Seed: %d" % game_seed
	Err.print("^ seed: " + str(game_seed))

func get_current_round():
	if (!current_career): return 0
	return current_career.current_round

## converts hex color to `Color`
func format_color(hex: int) -> Color:
	return Color.hex(hex)

## converts `Color` to rgba32 hex
func format_color_hex(col: Color) -> int:
	return col.to_rgba32()

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
	
func emit_scene(sc: String = "", condition = (func(): return true)):
	Stream.cache(func(): if (condition.call()): SignalBus.set_scene.emit(sc))

func validate_name(n: String) -> bool:
	return !Keyname.values().has(n)

## true pauses the game, false unpauses
func pause_game(switch: bool):
	Err.print("^ paused: " + str(switch))
	get_tree().paused = switch

func is_paused() -> bool:
	return get_tree().paused

# save/load functions

## saves current game state. if you have stuff after this call you want done after it saves, queue it in `Stream`
func save_state(to_backup = false):
	backup = to_backup
	FileUtil.set_save_path()
	if (backup): Err.print("/ saving to backup")
	main_node.prompt_game_save(FileUtil.save_dir_exists(true))

## called from `main_node`
func save_callable():
	Err.print("^ saving")
	Setting.save()
	var path = "%s/%s" % [FileUtil.save_path, Career.FILE_NAME]
	FileUtil.write_to_file(current_career.format_save(), path)
	for level in Levels:
		Levels[level].save_data(backup)
	main_node.save_game_end()
	#SignalBus.done_saving.emit()
	Err.print("^ saved")

func load_state(data: Dictionary = {}):
	var file_name = data.get("name", "")
	Err.print("^ loading %s" % file_name);
	FileUtil.set_save_path(file_name)

	for level in Levels.values():
		level.load_data()
		
	if (data == {}):
		current_career = null
	else:
		var lvl = Levels[data.level]
		current_career = Career.create(lvl, data.name, data.team_id)
		current_career.current_round = data.round - 1
		current_career.begin_round()
		set_seed(data.seed)

	SignalBus.done_loading.emit()
	for lvl in Levels.values():
		lvl.set_avg_rating()
	Err.print("^ loaded")
