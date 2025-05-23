class_name Team extends DataEntity

var fighters = []
var player: Player
var schedule = {} ## not stored in save
var color: Color ## stored as `Color` in game, int in save
var wins = 0
var losses = 0
var ties = 0
var cpu = true
var rank = 0

func _init(data = {}):
	super(data, "T")
	set_data(data, true)

func connect_objs():
	pass

func set_data(data: Dictionary, init = false) -> Team:
	if (!init): super(data)
	if (data == {}): return self
	set_color(data.get("color", color))
	wins = data.get("wins", wins)
	losses = data.get("losses", losses)
	ties = data.get("ties", ties)
	# this needs to be last
	if (!data.get("schedule")): return self
	for r_str in data["schedule"]:
		var r = int(r_str)
		schedule[r] = data["schedule"][r_str]
	return self

## called from `Fighter.set_team`
func add_fighter(f: Fighter):
	if (fighters.has(f)): return
	if (f.team != self):
		f.set_team(self)
	else:
		fighters.append(f)

## called from `Game.add_team`
func add_game(g: Game):
	if (g.rnd < 1): return
	if (!g.teams.has(self)):
		g.add_team(self)
	else:
		schedule[g.rnd] = g

func add_win():
	wins += 1

func add_loss():
	losses += 1

func add_tie():
	ties += 1

## called from `Player.set_team`
func set_player(p: Player):
	if (p.team != self):
		if (player):
			p.remove_team()
		p.set_team(self)
	else:
		player = p

func remove_game(r: int):
	if (schedule.get(r)):
		schedule[r] = null

func get_wins() -> int: 
	return wins

func get_losses() -> int:
	return losses

func get_game(r: int) -> Game:
	return schedule.get(r)

func get_opponent(r: int) -> Team:
	var g = schedule.get(r)
	return g.get_opponent(self) if (g) else null

func get_opponent_name(r:int) -> String:
	var opp = get_opponent(r)
	return opp.de_name if (opp) else Main.Keyname.Bye

## compiles stat used for rating
func get_rating() -> float:
	return (avg_f_rating() * Rating.AVG_F_WT) + (wins * Rating.WIN_WT) + (ties * Rating.TIE_WT) - (losses * Rating.LOSS_WT)

## average rating of all fighters on the team
func avg_f_rating() -> float:
	var total = 0.0
	for f in fighters:
		total += f.get_rating()
	return total / fighters.size()

func get_rating_scale() -> int:
	return level.get_team_rs(self)

func has_game(r: int) -> bool:
	return get_opponent(r) != null

func is_cpu() -> bool:
	return cpu

func is_ranked() -> bool:
	return rank > 0

func games_played() -> int:
	return wins + losses

func win_pct() -> float:
	if (games_played() == 0): return 0.0
	return wins as float / games_played()

func set_color(col):
	if (col is int || col is float):
		color = Main.format_color(col)
	elif (col is Color):
		color = col
	else:
		Err.alert_fatal("Invalid color type in %s" % id_str, Err.Fatal.Runtime)

# string functions

## returns rank and name
func str_rank_name(trim = false) -> String:
	var line = ""
	if (is_ranked()):
		if (trim):
			line += "%d " % rank
		else:	
			line += "%2d " % rank
	elif (!trim):
		line += "%3s" % ""
	line += name()
	return line

## W-L-T
func str_record() -> String:
	return "%d-%d-%d" % [wins, losses, ties]

## see `Game.str_result()`
func str_game(r: int, include_opp = false) -> String:
	return get_game(r).str_result(self, include_opp)

## returns first three letters if name is one word, or first letter of each word
func str_name_abbr() -> String:
	var words = de_name.split(" ")
	if (words.size() == 1):
		return de_name.left(3)
	else:
		var text = ""
		for word in words:
			text += word[0][0]
		return text

# format functions

func format_save() -> Dictionary:
	var data = super()
	data.merge({
		"season": season,
		"color": Main.format_color_hex(color),
		"series": series,
		"wins": wins,
		"losses": losses,
		"ties": ties,
	}, true)
	return data

func format_sched() -> Dictionary:
	var dict = {}
	for r in schedule:
		dict[r] = schedule[r].id
	return dict

func format_info() -> Dictionary:
	var info = {
		"Rating" = "%.f" % get_rating_scale(),
		"Record" = str_record(),
		"Series" = series,
		"League" = level.name,
	}
	return info


# test functions

func test_check_sync(r) -> bool:
	if (!has_game(r)): return true
	return self == get_opponent(r).get_opponent(r)
