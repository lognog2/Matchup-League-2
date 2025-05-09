class_name Player extends DataEntity

var teamID = -1
var team: Team

func _init(data = {}):
	super(data, "P")
	set_data(data, true)

func set_data(data: Dictionary, init = false) -> Player:
	if (!init): super(data)
	if (data == {}): return self
	teamID = data.get("team ID", -1)
	if (!data.get("schedule")): return self
	return self

func connect_objs():
	team = level.get_team(teamID)
	set_team(team)

func set_team(t: Team):
	if (!t):
		if (team):
			remove_team()
			team.cpu = true
	else:
		team = t
		team.cpu = false

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
		"name" = de_name,
		"team ID" =  teamID,
		}, true)
	return data
