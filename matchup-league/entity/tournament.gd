class_name Tournament extends DataEntity

var team_arr = [] ## all teams, no byes
var bracket = {} ## all teams and byes that haven't been eliminated. key is seed, value is team
var tourney_round = 0
var num_rounds = 0
const MAX_TEAMS = 128

enum Seeding {
	TRADITIONAL,
	NONE, 
}

## not used yet
enum Elimination {
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
	team_arr = data.get("team ids", team_arr)
	num_rounds = data.get("num rounds", num_rounds)
	config.merge(data.get("config", config), true)
	return self

func connect_objs():
	var teams = []
	for tid in team_arr:
		teams.append(level.get_team(tid))
	team_arr = teams
	fill_bracket()

## advance tournament to next round, remove teams that were eliminated
func advance():
	for seed in bracket.keys():
		var team = bracket[seed]
		var game = team.schedule.get(tourney_key())
		if (!game.has_winner()):
			Err.print_fatal("%s is unfinished" % game.id_str, Err.Fatal.Conflict)
			return
		if (!team.is_winner(game)):
			bracket.erase(seed)
	set_round_games()

## increases tourney round and sets games for new round
func set_round_games():
	tourney_round += 1
	if (config.reseed):
		fill_games_seeded()
	else:
		fill_games_position()

## fills bracket to full bracket number with existing teams and `null` as byes
func fill_bracket():
	if (team_arr.size() <= 1):
		Err.print_fatal("Not enough teams to start tournament", Err.Fatal.Insufficient)
		return
	elif (team_arr.size() > MAX_TEAMS):
		Err.print_fatal("Too many teams to start tournament", Err.Fatal.Invalid)
		return
	bracket = {}
	var i = 1
	var full = full_bracket_size()
	for team in team_arr:
		bracket[i] = team
		i += 1
	while (i <= full):
		bracket[i] = null
		i += 1

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
	for seed in bracket.keys():
		var t1 = bracket[seed]
		if (t1 && !t1.schedule.has(tourney_key())):
			var t2 = bracket[get_opponent_seed(num, seed)]
			create_game(t1, t2)

func get_opponent_seed(num: int, seed: int) -> int:
	var opp_seed = num + 1 - seed
	if (!bracket.has(seed)):
		Err.print("/ checking %d for seed" % seed)
		opp_seed = get_opponent_seed(num * 2, seed)
	Err.print("/ num: %d	seed: %d	opp_ seed: %d" % [num, seed, opp_seed])
	if (bracket.has(opp_seed)):
		Err.print("/ found opp seed!")
		return opp_seed
	else:
		Err.print("/ checking %d for seed" % opp_seed)
		return get_opponent_seed(num * 2, opp_seed)

func create_game(t1: Team, t2: Team) -> Game:
	var game = TourneyGame.create(t1, t2, self, tourney_round)
	return game

## array [i, r] where i is tournament id, and r is tournament round
func tourney_key(r = tourney_round) -> Array:
	return [id, r]

func is_complete() -> bool:
	return tourney_round > num_rounds

func get_team_ids() -> Array:
	var ids = []
	for t in team_arr:
		ids.append(t.id)
	return ids

## gets bracket size including byes.
## see manual for more in-depth explanation
func full_bracket_size() -> int:
	var n = ceil(log(bracket.size()) / log(2.0))
	num_rounds = n
	Err.print("/ number of rounds: %d" % num_rounds)
	var full_size = 2 ** n
	return full_size 

func format_save() -> Dictionary:
	var data = super()
	data.merge({
		"config" = config,
		"num rounds" = num_rounds,
		"team ids" = get_team_ids(),
	}, true)
	return data
