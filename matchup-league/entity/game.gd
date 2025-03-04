class_name Game extends DataEntity

var rnd: int
var teams = [null, null]
var teamIDs = [-1, -1]
var score = [0, 0]
var result = null

func _init(data: Dictionary):
	super(data, "G")
	set_data(data, true)
	
func set_data(data: Dictionary, init = false) -> Game:
	if (!init): super(data)
	rnd = data.get("round", rnd)
	teamIDs = [data.get("team1", teamIDs[0]), data.get("team2", teamIDs[1])]
	score = data.get("score", score)
	result = data.get("result", result)
	return self

func connect_objs():
	var new_teams = [level.get_team(teamIDs[0]), level.get_team(teamIDs[1])]
	set_teams(new_teams)

## adds a team to an empty slot in this game, returns false if both slots occupied
func add_team(t: Team) -> bool:
	if (!is_bye()): return false
	if (teamIDs[0] < 0):
		set_team(0, t)
		return true
	elif (teamIDs[1] < 0):
		set_team(1, t)
		return true
	else:
		return false

func set_teams(tms: Array):
	set_team(0, tms[0])
	set_team(1, tms[1])

func set_team(i: int, t: Team):
	if (teams[i]): teams[i].remove_game(rnd)
	teams[i] = t
	if (t): 
		teamIDs[i] = t.id
		t.add_game(self)
	else:
		teamIDs[i] = -1
		t.add_game(null)
	

func get_opponent(t: Team) -> Team:
	if t == teams[0]: return teams[1]
	elif t == teams[1]: return teams[0]
	print("* %s is not in game " % t.id_str, id_str)
	return null

func has_team(t: Team): return teams.has(t)

func has_team_id(s_id: int): return teamIDs.has(s_id)

func is_bye():
	return !teams[0] || !teams[1]

func finished(): return (result)
	
func format_save() -> Dictionary:
	verify()
	var data = super()
	data.erase("name")
	data.merge({
		"round": rnd,
		"team1": teamIDs[0],
		"team2": teamIDs[1],
		"score": score,
		"result": result
	}, true)
	return data

# test functions

func verify() -> bool:
	var exit = Err.Success.Success
	if (is_bye()): return true
	if (teams[0].id != teamIDs[0] || teams[1].id != teamIDs[1]):
		exit = Err.Fatal.Conflict
	elif (rnd <= 0):
		exit = Err.Fatal.Conflict
	if (exit < 0):
		Err.alert_fatal("Integrity of %s could not be verified" % id_str, exit)
	return exit == Err.Success.Success
