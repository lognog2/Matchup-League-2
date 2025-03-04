class_name Team extends DataEntity

var fighters = []
var schedule= {}
var color
var won = 0
var lost = 0

func _init(data: Dictionary):
	super(data, "T")
	set_data(data, true)

func connect_objs():
	pass

func set_data(data: Dictionary, init = false) -> Team:
	if (!init): super(data)
	color = data.get("color", color)
	if (!data.get("schedule")): return
	for r_str in data["schedule"]:
		var r = int(r_str)
		schedule[r] = data["schedule"][r_str]
	return self

func add_fighter(f: Fighter):
	if (fighters.has(f)): return
	if (f.team != self):
		f.set_team(self)
	else:
		fighters.append(f)

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
	
# format functions

func format_save() -> Dictionary:
	var data = super()
	data.merge({
		"season": season,
		"color": color,
		#"schedule": format_sched()
	}, true)
	return data

func format_sched() -> Dictionary:
	var dict = {}
	for r in schedule:
		dict[r] = schedule[r].id
	return dict

func format_info() -> Dictionary:
	var info = {
		"League": level.name,
		"Record": "%d-%d" % [won, lost]
	}
	return info

# test functions

func check_sync(r) -> bool:
	if (!has_game(r)): return true
	return self == get_opponent(r).get_opponent(r)
