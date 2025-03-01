class_name Level extends Object

#init vars
var name: String
var FPT: int
var f_fileName: String
var t_fileName: String
var g_fileName: String

#id vars
var f_lastID = 0
var t_lastID = 0
var g_lastID = 0

#dicts
var fighterDict = {}
var teamDict = {}
var gameDict = {}

## selection filters
var Filter = {
	Default = (func(_de): return true)
}

## sorting filters
var Sort = {
	Id = (func(a: DataEntity, b: DataEntity): 
		return a.id < b.id),
	Alphabet = (func(a: DataEntity, b: DataEntity): 
		return a.name.naturalcasecmp_to(b.name) < 0),
	Default = (func(_a: DataEntity, _b: DataEntity): 
		return false;)
}

func _init(levelName: String, fpt = 100):
	name = levelName
	FPT = fpt
	f_fileName = "%s_fighters" % name.to_lower()
	t_fileName = "%s_teams" % name.to_lower()
	g_fileName = "%s_games" % name.to_lower()

func get_fighter(id: int): return fighterDict.get(id) if (id >= 0) else null

func get_team(id: int): return teamDict.get(id) if (id >= 0) else null

func get_game(id: int): return gameDict.get(id) if (id >= 0) else null

## find a game
func find_game(r: int, oppID: int) -> Game:
	var result = get_games(
		func (g: Game):
			if (g.rnd == r && g.has_team_id(oppID)):
				return true
			else: return false
	)
	if (result.size() != 1):
		return null
	else:
		return result[0]

# get list by filter

func get_fighters(filter = Filter.Default) -> Array: 
	return get_entities(fighterDict, filter)

func get_teams(filter = Filter.Default) -> Array: 
	return get_entities(teamDict, filter)

func get_games(filter = Filter.Default) -> Array: 
	return get_entities(gameDict, filter)

func get_teams_sorted(filter = Sort.Alphabet) -> Array:
	return get_entities(teamDict, Filter.Default, filter)

func get_entities(dict: Dictionary, select_filter = Filter.Default, sort_filter = null) -> Array:
	var validEntities = []
	for val in dict.values():
		if (select_filter.call(val)):
			validEntities.append(val)
	if (sort_filter): validEntities.sort_custom(sort_filter)
	return validEntities


func get_f_names(filter = Filter.Default) -> Array: 
	return get_names(fighterDict, filter)

func get_t_names(filter = Filter.Default) -> Array: 
	return get_names(teamDict, filter)

func get_names(dict: Dictionary, filter = Filter.Default) -> Array:
	var validNames = []
	for val in dict.values():
		if (filter.call(val)):
			validNames.append(val.name)
	validNames.sort()
	return validNames

func find_fighter(n: String): return find_entity(fighterDict, n)
func find_team(n: String): return find_entity(teamDict, n)

## returns first instance of name in dictionary
func find_entity(dict: Dictionary, ent_name: String) -> DataEntity:
	if (!Main.validate_name(ent_name)): return null
	var matches = get_entities(dict, func (de): return de.name == ent_name)
	if (matches.size() != 1):
		return null
	else:
		return matches[0]

func random_team(): return random_entity(teamDict)

func random_entity(dict: Dictionary) -> DataEntity:
	var id = randi() % dict.size()
	return dict[id]

# save/load from file
# **be careful using breakpoints here**

func addNewFighter(data: Dictionary) -> int:
	data["id"] = f_lastID
	f_lastID += 1
	return set_fighter(data)

func set_fighter(data: Dictionary) -> int:
	var fighter = Fighter.new(data)
	if (fighter.id >= f_lastID): 
		f_lastID = fighter.id + 1
	fighterDict[fighter.id] = fighter
	return fighter.id
	
func add_team(data: Dictionary) -> int:
	data["id"] = t_lastID
	t_lastID += 1
	return set_team(data)

func set_team(data: Dictionary) -> int:
	var team = Team.new(data)
	if (team.id >= t_lastID): 
		t_lastID = team.id + 1
	teamDict[team.id] = team
	return team.id

func add_game(data: Dictionary) -> int:
	data["id"] = g_lastID
	g_lastID += 1
	return set_game(data)

func set_game(data: Dictionary) -> int:
	var game = Game.new(data)
	if (game.id >= g_lastID): 
		g_lastID = game.id + 1
	gameDict[game.id] = game
	return game.id

func save_data(softSave: bool):
	print("/ last chance to look at the save data, programmer")
	save_to_file(softSave, f_fileName, fighterDict)
	save_to_file(softSave, t_fileName, teamDict)
	save_to_file(softSave, g_fileName, gameDict)

func save_to_file(softSave: bool, file_name: String, dict: Dictionary):
	var file = FileAccess.open("res://data/%s.save" % file_name, FileAccess.WRITE)
	var backupFile
	if (!softSave): backupFile = FileAccess.open("res://data/%s_backup.save" % file_name, FileAccess.WRITE)
	for id in dict:
		var data = dict[id].format_save()
		var json_data = JSON.stringify(data)
		file.store_line(json_data)
		if (!softSave): backupFile.store_line(json_data)

func load_data():
	load_from_file(f_fileName, Callable(self, "set_fighter"))
	load_from_file(t_fileName, Callable(self, "set_team"))
	load_from_file(g_fileName, Callable(self, "set_game"))

func load_from_file(fileName: String, setEntity: Callable):
	var file = FileAccess.open("res://data/%s.save" % fileName, FileAccess.READ)
	if (!file): return
	while file.get_position() < file.get_length():
		var line = file.get_line()
		var json = JSON.new()
		if json.parse(line) != OK:
			print("! JSON Parse Error: ", json.get_error_message(), " in ", line, " at line ", json.get_error_line())
			continue
		var data = json.data
		data["level name"] = name
		data["season"] = Main.get_season()
		setEntity.call(data)
	
class LevelEntity:
	var dict: Dictionary
	var file_name
