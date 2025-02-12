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

func _init(levelName: String, fpt = 100):
	name = levelName
	FPT = fpt
	f_fileName = "%s_fighters" % name.to_lower()
	t_fileName = "%s_teams" % name.to_lower()

func getFighter(id: int): return fighterDict[id]

func getTeam(id: int):  return teamDict[id]

func addNewFighter(data: Dictionary):
	data["id"] = f_lastID
	f_lastID += 1
	return setFighter(data)

func setFighter(data: Dictionary):
	var fighter = Fighter.new(data)
	if (fighter.id >= f_lastID): 
		f_lastID = fighter.id + 1
	fighterDict[fighter.id] = fighter
	return fighter.id
	
func addNewTeam(data: Dictionary):
	data["id"] = t_lastID
	t_lastID += 1
	return setTeam(data)

func setTeam(data: Dictionary):
	var team = Team.new(data)
	if (team.id >= t_lastID): 
		t_lastID = team.id + 1
	teamDict[team.id] = team
	return team.id

func getTeamsSorted():
	var vals = teamDict.values()
	vals.sort()
	return vals
	
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
	loadFromFile(f_fileName, Callable(self, "setFighter"))
	loadFromFile(t_fileName, Callable(self, "setTeam"))

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
	
