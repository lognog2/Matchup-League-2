class_name Team extends DataEntity

var fighters = []
var schedule = {} ## not stored in save
var color: Color ## stored as `Color` in game, int in save
var won = 0
var lost = 0

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
	if (!g.teams.has(self)):
		g.add_team(self)
	else:
		schedule[g.rnd] = g

func remove_game(r: int):
	schedule[r] = null

func get_game(r: int) -> Team:
	return get_opponent(r)

func get_opponent(r: int) -> Team:
	var g = schedule.get(r)
	return g.get_opponent(self) if (g) else null

func get_opponent_name(r:int) -> String:
	var opp = get_opponent(r)
	return opp.name if (opp) else Main.Keyname.Bye

func has_game(r: int) -> bool:
	return get_opponent(r) != null

func games_played() -> int:
	return won + lost

func set_color(col):
	if (col is int || col is float):
		color = format_color(col)
	elif (col is Color):
		color = col
	else:
		Err.alert_fatal("Invalid color type in %s" % id_str, Err.Fatal.Runtime)
	
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
		"Series": series,
		"League": level.name,
		"Record": format_record()
	}
	return info

##converts wins and losses to string: w-l
func format_record(w = won, l = lost) -> String:
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
