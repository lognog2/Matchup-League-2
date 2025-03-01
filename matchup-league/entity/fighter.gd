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
	types = types_arr(data["types"])
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

func types_arr(type_str = types) -> Array:
	if (!type_str is String): return []
	var type_arr = []
	if (type_str.length() > Main.MAX_TYPES):
		type_str.left(Main.MAX_TYPES)
	for i in type_str.length():
		type_arr.append(type_str[i])
	return type_arr

func types_str(type_arr = types) -> String:
	if (!type_arr is Array): return ""
	var type_str = ""
	for type in type_arr:
		type_str = type_str + "(%s) " % type
	return type_str


func setBase(new):
	if (new < Main.MIN_BASE):
		new = Main.MIN_BASE
	elif (new > Main.MAX_BASE):
		new = Main.MAX_BASE
	return new
		
func setMod(new):
	if (new < Main.MIN_MOD):
		new = Main.MIN_MOD
	elif (new > Main.MAX_MOD):
		new = Main.MAX_MOD
	return new

#format functions

func mod_str(use_strength = true) -> String:
	var type = ""
	var pm = ""
	var val = 0
	if (use_strength):
		type = strType
		val = strVal
		pm = "+"
	else:
		type = wkType
		val = wkVal
		pm = "-"
	
	return "(%s) %s%d" % [type, pm, val]

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
