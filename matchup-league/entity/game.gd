class_name Game extends DataEntity

var rnd: int
var teams = [null, null]
var teamIDs = [-1, -1]
var score = [0, 0]
var result = null #index of winning team, or -1 for a tie
var matches = []

func _init(data = {}):
	super(data, "G")
	set_data(data, true)
	
func set_data(data: Dictionary, init = false) -> Game:
	if (!init): super(data)
	if (data == {}): return self
	rnd = data.get("round", rnd)
	teamIDs = [data.get("team1id", teamIDs[0]), data.get("team2id", teamIDs[1])]
	matches = data.get("matches", matches)
	result = data.get("result", result)
	#if (data.get("connect")): connect_objs()
	return self

func connect_objs():
	var new_teams = [level.get_team(teamIDs[0]), level.get_team(teamIDs[1])]
	set_teams(new_teams)
	set_matches()

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

func get_team_index(t: Team) -> int:
	for i in range (teams.size()):
		if (teams[i] == t):
			return i
	Err.alert_warn(t.id_str + " not found in " + id_str, 0)
	return -3

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
	
## converts matches from array of id pairs to match objects, then calls `set_current_score()`
func set_matches():
	for m in matches:
		m = Match.new(self, level.get_fighter(m[0]), level.get_fighter(m[1]))
	set_current_score()

## sets score according to existing matches
func set_current_score():
	if (matches.is_empty()): return
	for m in matches:
		var r = m.run_match().result
		if (r >= 0): score[r] += m.match_val

## call this when game is finished
func set_result():
	#kinda messy but not gonna bother with a better way
	if (is_official()):
		if (score[0] > score[1]):
			result = 0
			teams[0].add_win()
			teams[1].add_loss()
		elif (score[1] > score[0]):
			result = 1
			teams[1].add_win()
			teams[0].add_loss()
		else:
			result = -1
			for t in teams:
				t.add_tie()
	else:
		if (score[0] > score[1]):
			result = 0
		elif (score[1] > score[0]):
			result = 1
		else:
			result = -1
		
func get_opponent(t: Team) -> Team:
	if t == teams[0]: return teams[1]
	elif t == teams[1]: return teams[0]
	print("* %s is not in game " % t.id_str, id_str)
	return null

## returns winning team, or null if a tie or unfinished
func get_winner() -> Team:
	if (result == 0):
		return teams[0]
	elif (result == -1):
		return teams[1]
	else:
		return null

## gets sum of both teams' rating
func get_rating():
	if (is_bye()): return 0.0
	return teams[0].get_rating() + teams[1].get_rating()

func unplayed_fighters(t: Team) -> Array:
	var i = get_team_index(t)
	var unplayed = Array(t.fighters)
	for m in matches:
		unplayed.remove(m.fighters[i])
	return unplayed

func has_team(t: Team) -> bool: 
	return teams.has(t)

func has_team_id(s_id: int) -> bool:
	return teamIDs.has(s_id)

func is_bye() -> bool:
	return !teams[0] || !teams[1]

func is_official() -> bool:
	return rnd > 0

func is_done() -> bool:
	return is_finished()

func is_finished() -> bool: 
	return (result != null)

## simulates a game as 2 cpu players choosing fighters randomly
func sim_game():
	if (is_finished()): 
		#Err.alert_warn(id_str + " already finished", Err.Warn.NoAction)
		return
	var f_available = [[],[]]
	var f_played = [[],[]]
	for i in range (2):
		f_available[i] = teams[i].fighters
	
	for i in range (level.FPG):
		var f1 = f_available[0].pick_random()
		var f2 = f_available[1].pick_random()
		run_match(f1, f2)
		f_played[0].append(f1)
		f_available[0].erase(f1)
		f_played[1].append(f2)
		f_available[1].erase(f2)

	for i in range (2):
		f_available[i].append_array(f_played[i])
		teams[i].fighters = f_available[i]
		
	set_result()

## returns match
func run_match(f1: Fighter, f2: Fighter) -> Match:
	var m = Match.new(self, f1, f2)
	matches.append(m)
	var r = m.result
	if (r >= 0): score[r] += m.match_val
	return m
	
# string functions

## takes index of team and returns char representing its result
## returns T for tie, W for win, L for loss, or blank if unfinished
func result_char(idx: int) -> String:
	if (!is_finished()): return ""
	if (result == -1):
		return "T"
	elif (result == idx):
		return "W"
	else:
		return "L"

## gets result and score from one teams's perspective.
## if game is not finished, returns empty string
func result_str(t: Team, include_opp = false) -> String:
	var i = get_team_index(t)
	var k = i - 1
	var text = ""
	if (include_opp):
		text = "%d) vs %s" % [rnd, teams[k].name()]
	if (is_finished()):
		if (include_opp): text += ": "
		text += "%s %d-%d" % [result_char(i), score[i], score[k]]
	return text

# format functions

func format_save() -> Dictionary:
	verify()
	var data = super()
	data.erase("name")
	data.merge({
		"round": rnd,
		"team1id": teamIDs[0],
		"team2id": teamIDs[1],
		"result": result,
		"matches": format_matches(),
	}, true)
	return data

func format_matches() -> Array:
	var arr = []
	for m in matches:
		arr.append([m.fighters[0].id, m.fighters[1].id])
	return arr
	

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
	

class Match:
	var fighters = [null, null]
	var game: Game
	var result
	var match_val = 1
	var ModApplied = {
		str1 = false,
		str2 = false,
		wk1 = false,
		wk2 = false
	}
	
	func _init(g: Game, f1: Fighter, f2: Fighter, val = 1):
		game = g
		fighters = [f1, f2]
		match_val = val
		run_match()
		
	## returns result: 0 if f1 wins, 1 if f2 wins, -1 if tie
	## param `record` is whether or not to count result towards fighter stats
	func run_match(record = false) -> Match:
		if (!game.is_official()): record = false
		var f1 = fighters[0]
		var f2 = fighters[1]
		var points1 = f1.base
		var points2 = f2.base
		ModApplied.str1 = check_mod(f1.strType, f2.types)
		if (ModApplied.str1):
			points1 += f1.strVal
		ModApplied.str2 = check_mod(f2.strType, f1.types)
		if (ModApplied.str2):
			points2 += f2.strVal
		ModApplied.wk1 = check_mod(f1.wkType, f2.types)
		if (ModApplied.wk1):
			points1 -= f1.wkVal
		ModApplied.wk2 = check_mod(f2.wkType, f1.types)
		if (ModApplied.wk2):
			points2 -= f2.wkVal
		
		if (points1 > points2):
			if (record):
				f1.add_win()
				f2.add_loss()
			result = 0
		elif (points2 > points1):
			if (record):
				f1.add_loss()
				f2.add_win()
			result = 1
		else:
			result = -1
		return self

	func check_mod(check: Variant, types: Array) -> bool:
		return types.has(check)
		
	
	
