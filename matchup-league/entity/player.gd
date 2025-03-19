class_name Player extends DataEntity

var teamID: int
var team: Team

func _init(data = {}):
	super(data, "P")
	set_data(data, true)

func connect_objs():
	team = level.get_team(teamID)
	set_team(team)

func set_data(data: Dictionary, init = false) -> Player:
	if (!init): super(data)
	if (data == {}): return self
	if (!data.get("schedule")): return self
	return self

func set_team(t: Team):
	if (!t):
		remove_team()
	else:
		team = t

func remove_team():
	if (!team):
		Err.print_warn("no team to remove from %s" % id_str, Err.Warn.NoAction)
		return
	team.remove_player()
	team = null

func get_rating() -> float:
	return team.get_rating() if (team) else 0.0

func format_save():
	var data = super()
	data.merge({
		"id" = id,
		"name" = name,
		"team ID" =  teamID,
		}, true)
	return data
