class_name Tournament extends DataEntity

var team_arr = [] ## all teams, no byes
var bracket = {} ## all teams and byes that haven't been eliminated. key is seed, value is team
var full_bracket_size = 0
var tourney_round = 1
const MAX_TEAMS = 128

enum Seeding {
	TRADITIONAL,
	NONE, 
}

## not used yet
enum Elim {
	SINGLE = 1,
	DOUBLE = 2,
	TRIPLE = 3
}

var config = {
	seeding = Seeding.TRADITIONAL,
	reseed = false,     # reseed remaining teams after each round
}

func _init(data = {}):
	super(data, "TN")
	set_data(data, true)
	
func set_data(data: Dictionary, init = false) -> Tournament:
	if (!init): super(data)
	if (data == {}): return self
	tourney_round = data.get("round", tourney_round)
	team_arr = data.get("team ids", team_arr)
	config.merge(data.get("config", config), true)
	bracket = data.get("bracket", bracket)
	return self

func connect_objs():
	var teams = []
	for tid in team_arr:
		teams.append(level.get_team(tid))
	for sd in bracket.keys():
		bracket[int(sd)] = level.get_team(bracket[sd])
		bracket.erase(sd)
	team_arr = teams
	fill_bracket()

## advance tournament to next round,
## remove teams that were eliminated and bye slots
func advance():
	#Err.print("/ advance")
	for seeding in bracket.keys():
		var team = bracket.get(seeding)
		var erase = false
		if (!team):
			erase = true
		else:
			var game = team.get_game(tourney_key())
			if (game && !team.is_winner(game)):
				erase = true
				if (!game.has_winner()):
					Err.print_fatal("%s does not have a winner" % game.id_str, Err.Fatal.Conflict)
					return
				
		if (erase):
			bracket.erase(seeding)
			
	tourney_round += 1
	if (!is_done()):
		set_round_games()

## increases tourney round and sets games for new round
func set_round_games():
	
	if (config.reseed):
		fill_games_seeded()
	else:
		fill_games_position()

## fills bracket to full bracket number with existing teams and `null` as byes
func fill_bracket():
	if (team_arr.size() < 2):
		Err.print_fatal("Not enough teams to start tournament", Err.Fatal.Insufficient)
		return
	if (team_arr.size() > MAX_TEAMS):
		Err.print_fatal("Too many teams to start tournament", Err.Fatal.Invalid)
		return
	if (!bracket.is_empty()): return

	var i = 1
	full_bracket_size = get_full_bracket_size()
	for team in team_arr:
		bracket[i] = team
		team.rank = i
		i += 1
	while (i <= full_bracket_size):
		bracket[i] = null
		i += 1
	
	set_round_games()

## each round, place the highest and lowest seed in one game, then second highest and lowest, etc
func fill_games_seeded():
	var entries = bracket.values()
	var a = 1
	var b = entries.size()
	while a < b:
		var t1 = entries.get(a)
		var t2 = entries.get(b)
		if (t1 && t2):
			create_game(t1, t2)
		a += 1
		b -= 1

## places teams in traditional tournament format,
## see manual for explanation
func fill_games_position():
	var num = bracket.size()
	for seeding in bracket.keys():
		var t1 = bracket[seeding]
		if (t1 && !t1.has_game(tourney_key())):
			var t2 = bracket[get_opponent_seed(num, seeding)]
			create_game(t1, t2)

func is_done() -> bool:
	return (bracket.size() < 2)

func get_opponent_seed(num: int, seeding: int) -> int:
	if (num > full_bracket_size):
		return 0
	var opp_seed = num + 1 - seeding
	Err.print("/ num: %d | seeding: %d | opp seeding: %d" % [num, seeding, opp_seed])
	if (bracket.has(opp_seed)):
		#Err.print("/ found opp seed!")
		return opp_seed
	else:
		var next_check = get_opponent_seed(num * 2, opp_seed)
		if (next_check > 0):
			return next_check
		else:
			return get_opponent_seed(num * 2, seeding) 

func create_game(t1: Team, t2: Team) -> Game:
	if (!t1 || !t2): return
	var g_data = get_basic_data()
	g_data.merge ({
		"team1id" = Level.get_id(t1),
		"team2id" = Level.get_id(t2),
		"round" = tourney_key(),
	})
	var game = level.add_game(g_data, true)
	return game

## array `[i, r]` where i is tournament id, and r is tournament round
func tourney_key(r = tourney_round) -> Array:
	return [id, r]

## gets bracket size including byes.
## see manual for more in-depth explanation
func get_full_bracket_size() -> int:
	var n = ceil(log(team_arr.size()) / log(2.0))
	var full_size = 2 ** n
	return full_size 

func get_team_ids() -> Array:
	var ids = []
	for t in team_arr:
		ids.append(t.id)
	return ids

func format_bracket() -> Dictionary:
	var dict = {}
	for seeding in bracket.keys():
		var team = bracket[seeding]
		dict[seeding] = team.id if (team) else null
	return dict

func format_save() -> Dictionary:
	var data = super()
	data.merge({
		"config" = config,
		"team ids" = get_team_ids(),
		"bracket" = format_bracket(),
		"round" = tourney_round,
	}, true)
	return data
