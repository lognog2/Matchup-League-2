class_name Fighter extends DataEntity

#match vars
var types
var base
var strType
var strVal
var wkType
var wkVal #stored as positive

#team vars
var teamID = -1
var team
var contract
var retirement

var startSeason
var potential

#record vars
var matchesPlayed
var matchesWon

func _init(data: Dictionary):
	super(data)
	types = data["types"]
	base = setBase(data["base"])
	strType = data["strType"]
	strVal = setMod(data["strVal"])
	wkType = data["wkType"]
	wkVal = setMod(data["wkVal"])
	startSeason = data["start season"]
	teamID = data["team ID"]
	
func connect_objs():
	if (teamID >= 0):
		team = level.get_team(teamID)
		team.add_fighter(self)

func setTypes(typeStr: String):
	var typeArr = []
	if (typeStr.length > main.MAX_TYPES):
		typeStr.left(main.MAX_TYPES)
	for i in typeStr.length():
		typeArr.append(typeStr[i])
	return typeArr

func setBase(new):
	if (new < main.MIN_BASE):
		new = main.MIN_BASE
	elif (new > main.MAX_BASE):
		new = main.MAX_BASE
	return new
		
func setMod(new):
	if (new < main.MIN_MOD):
		new = main.MIN_MOD
	elif (new > main.MAX_MOD):
		new = main.MAX_MOD
	return new

func format_save() -> Dictionary:
	var data = {
		"id": id,
		"name": name,
		"season": season,
		"types": types,
		"base": base,
		"strType": strType,
		"strVal": strVal,
		"wkType": wkType,
		"wkVal": wkVal,
		"start season": startSeason,
		"team ID": teamID
	}
	return data