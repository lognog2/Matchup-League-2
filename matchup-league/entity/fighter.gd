class_name Fighter extends DataEntity

#match vars
var types
var base
var strType
var strVal
var wkType
var wkVal ##stored as positive

#team vars
var teamID = -1
var team ## only edit using set_team
var contract
var retirement

var startSeason
var potential

#record vars
var matches_won = 0
var matches_lost = 0

func _init(data = {}):
	super(data, "F")
	set_data(data, true)
	
func connect_objs():
	if (teamID >= 0):
		set_team(level.get_team(teamID))
		set_series(team.series) #prep only

func set_data(data: Dictionary, init = false) -> Fighter:
	if (!init): super(data)
	if (data == {}): return self
	types = types_arr(data.get("types", types))
	base = setBase(data.get("base", base))
	strType = data.get("strType", strType)
	strVal = setMod(data.get("strVal", strVal))
	wkType = data.get("wkType", wkType)
	wkVal = setMod(data.get("wkVal", wkVal))
	startSeason = data.get("start season", season)
	teamID = data.get("team ID", teamID)
	matches_won = data.get("wins", matches_won)
	matches_lost = data.get("losses", matches_lost)
	if (!init): set_team(level.get_team(teamID))
	return self

func set_team(t: Team):
	if (t == team): 
		return
	team = t
	teamID = team.id
	team.add_fighter(self)

## returns an array of types from a character string. ex: ABC -> [A, B, C]
func types_arr(type_str = types) -> Array:
	if (!type_str is String): return []
	var type_arr = []
	if (type_str.length() > Main.MAX_TYPES):
		type_str.left(Main.MAX_TYPES)
	for i in type_str.length():
		type_arr.append(type_str[i])
	return type_arr

## returns each type's character as a string. ex: ABC
func types_str(type_arr = types) -> String:
	if (!type_arr is Array): return ""
	var type_str = ""
	for type in type_arr:
		type_str += type
	return type_str

## returns a string of icons: (A)(B)(C)
func types_icon(type_arr = types) -> String:
	if (!type_arr is Array): return ""
	var type_str = ""
	for type in type_arr:
		type_str += "(%s) " % type
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

## compiles fighter rating from stats
func get_rating() -> float:
	return (base * Rating.BASE_WT) + (strVal * Rating.STR_WT) - (wkVal * Rating.WK_WT)

func win_pct() -> float:
	if (matches_played() == 0):
		return NodeUtil.float_zero()
	return float(matches_won) / matches_played()
	
func get_wins() -> int:
	return matches_won

func get_losses() -> int:
	return matches_lost

func add_win():
	matches_won += 1

func add_loss():
	matches_lost += 1

func matches_played() -> int:
	return matches_won + matches_lost

func no_contests() -> int:
	return Main.get_current_round() - matches_played()

#format functions

## set param true for strength, false for weakness
func str_mod(use_strength = true) -> String:
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

## string with matches won and matches played: "W/P"
func str_matches() -> String:
	return "%d/%d" % [matches_won, matches_played()]

func str_name_matches() -> String:
	return de_name + " " + str_matches()

func format_save() -> Dictionary:
	var data = {
		"id": id,
		"name": de_name,
		"season": season,
		"types": types_str(),
		"base": base,
		"strType": strType,
		"strVal": strVal,
		"wkType": wkType,
		"wkVal": wkVal,
		"start season": startSeason,
		"team ID": teamID,
		"wins": matches_won,
		"losses": matches_lost,
	}
	return data
