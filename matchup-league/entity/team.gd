class_name Team extends DataEntity

var fighters = []
var player: Player
var schedule = {} ## not stored in save
var color: Color ## stored as `Color` in game, int in save
var wins = 0
var losses = 0
var is_cpu = true
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

func get_game(r: int) -> Team:
	return get_opponent(r)

func get_opponent(r: int) -> Team:
	var g = schedule.get(r)
	return g.get_opponent(self) if (g) else null

func get_opponent_name(r:int) -> String:
	var opp = get_opponent(r)
	return opp.name if (opp) else Main.Keyname.Bye

## compiles stat used for rating
func get_rating() -> float:
	return avg_f_rating() 

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

func games_played() -> int:
	return wins + losses

func win_pct() -> float:
	if (games_played() == 0): return 0.0
	return wins as float / games_played()

func set_color(col):
	if (col is int || col is float):
		color = format_color(col)
	elif (col is Color):
		color = col
	else:
		Err.alert_fatal("Invalid color type in %s" % id_str, Err.Fatal.Runtime)

# string functions

## returns rank and name
func rank_name(trim = false) -> String:
	if (rank >= 10):
		return "%d) %s" % [rank, name]
	elif (rank > 0):
		return "  %d) %s" % [rank, name]
	elif (trim):
		return name
	else:
		return "     %s" % name

func record_str() -> String:
	return "%d-%d" % [wins, losses]

# format functions

func format_save() -> Dictionary:
	var data = super()
	data.merge({
		"season": season,
		"color": format_color_hex(color),
		"series": series,
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
		"Series" = series,
		"League" = level.name,
		"Record" = format_record()
	}
	return info

##converts wins and losses to string: w-l
func format_record(w = wins, l = losses) -> String:
	return "%d-%d" % [w, l]

## converts hex color to `Color`
func format_color(hex: int) -> Color:
	return Color.hex(hex)

## converts `Color` to rgba32 hex
func format_color_hex(col: Color = color) -> int:
	return col.to_rgba32()

# test functions

func check_sync(r) -> bool:
	if (!has_game(r)): return true
	return self == get_opponent(r).get_opponent(r)
