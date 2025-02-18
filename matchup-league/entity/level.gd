class_name Level extends Object

#init vars
var name: String
var FPT: int
var f_fileName: String
var t_fileName: String

#id vars
var f_lastID = 0
var t_lastID = 0
var lg_lastID = 0

#dicts
var fighterDict = {}
var teamDict = {}

#selection filters
var DEFAULT_FILTER = (func(_de: DataEntity): return true)

var SORT_ID = (func(a: DataEntity, b: DataEntity): return a.id > b.id)
var SORT_ALPHABET = (func(a: DataEntity, b: DataEntity): return a.name < b.name)

func _init(levelName: String, fpt = 100):
	name = levelName
	FPT = fpt
	f_fileName = "%s_fighters" % name.to_lower()
	t_fileName = "%s_teams" % name.to_lower()

func get_fighter(id: int): return fighterDict[id] if (id >= 0) else null

func get_team(id: int):  return teamDict[id] if (id >= 0) else null

# get list by filter

func get_fighters(filter = DEFAULT_FILTER) -> Array: 
	return get_entities(fighterDict, filter)

func get_teams(filter = DEFAULT_FILTER) -> Array: 
	return get_entities(teamDict, filter)

func get_teams_sorted(filter = SORT_ALPHABET) -> Array:
	return get_entities(teamDict, DEFAULT_FILTER, filter)

func get_entities(dict: Dictionary, filter = DEFAULT_FILTER, sortFilter = null) -> Array:
	var validEntities = []
	for val in dict.values():
		if (filter.call(val)):
			validEntities.append(val)
	if (sortFilter): validEntities.sort_custom(sortFilter)
	return validEntities

func get_f_names(filter = DEFAULT_FILTER) -> Array: 
	return get_names(fighterDict, filter)

func get_t_names(filter = DEFAULT_FILTER) -> Array: 
	return get_names(teamDict, filter)

func get_names(dict: Dictionary, filter = DEFAULT_FILTER) -> Array:
	var validNames = []
	for val in dict.values():
		if (filter.call(val)):
			validNames.append(val.name)
	validNames.sort()
	return validNames


# save/load from file
# **be careful using breakpoints here**

func addNewFighter(data: Dictionary):
	data["id"] = f_lastID
	f_lastID += 1
	return set_fighter(data)

func set_fighter(data: Dictionary):
	var fighter = Fighter.new(data)
	if (fighter.id >= f_lastID): 
		f_lastID = fighter.id + 1
	fighterDict[fighter.id] = fighter
	return fighter.id
	
func addNewTeam(data: Dictionary):
	data["id"] = t_lastID
	t_lastID += 1
	return set_team(data)

func set_team(data: Dictionary):
	var team = Team.new(data)
	if (team.id >= t_lastID): 
		t_lastID = team.id + 1
	teamDict[team.id] = team
	return team.id

func saveToFile(softSave: bool):
	var file = FileAccess.open("res://data/%s.save" % f_fileName, FileAccess.WRITE)
	var backupFile
	if (!softSave): backupFile = FileAccess.open("res://data/%s_backup.save" % f_fileName, FileAccess.WRITE)
	for f in fighterDict:
		var data = fighterDict[f].format_save()
		var json_data = JSON.stringify(data)
		file.store_line(json_data)
		if (!softSave): backupFile.store_line(json_data)
	
	file = FileAccess.open("res://data/%s.save" % t_fileName, FileAccess.WRITE)
	if (!softSave): backupFile = FileAccess.open("res://data/%s_backup.save" % t_fileName, FileAccess.WRITE)
	for t in teamDict:
		var data = teamDict[t].format_save()
		var json_data = JSON.stringify(data)
		file.store_line(json_data)
		if (!softSave): backupFile.store_line(json_data)

func loadData():
	loadFromFile(f_fileName, Callable(self, "set_fighter"))
	loadFromFile(t_fileName, Callable(self, "set_team"))

func loadFromFile(fileName: String, setEntity: Callable):
	var file = FileAccess.open("res://data/%s.save" % fileName, FileAccess.READ)
	if (!file): return
	while file.get_position() < file.get_length():
		var line = file.get_line()
		var json = JSON.new()
		if json.parse(line) != OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", line, " at line ", json.get_error_line())
			continue
		var data = json.data
		data["level"] = name
		setEntity.call(data)
	
