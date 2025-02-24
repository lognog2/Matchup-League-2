class_name Team extends DataEntity

var fighters = []
var schedule= {}
var color
var games_won = 0
var games_played = 0

func _init(data: Dictionary):
	super(data)
	color = data.get("color", color)
	if (!data.get("schedule")): return
	for r_str in data["schedule"]:
		var r = int(r_str)
		schedule[r] = data["schedule"][r_str]

func connect_objs():
	pass

func add_fighter(f: Fighter):
	fighters.append(f)

func add_game(g: Game):
	schedule[g.rnd] = g

func remove_game(r: int):
	schedule[r] = null

func get_game(r: int) -> Team:
	return get_opponent(r)

func get_opponent(r: int) -> Team:
	var g = schedule.get(r)
	return g.get_opponent(self) if (g) else null

func has_game(r: int) -> bool:
	return get_opponent(r) != null

func games_lost() -> int:
	return games_played - games_won
	
# test functions

func check_sync(r) -> bool:
	if (!has_game(r)): return true
	return self == get_opponent(r).get_opponent(r)

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
		"Record": "%d-%d" % [games_won, games_lost()]
	}
	return info
