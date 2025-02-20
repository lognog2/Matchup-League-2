class_name Game extends DataEntity

var round: int
var teams = []
var winner_idx = -1

func _init(data: Dictionary):
	super(data)
	round = data["round"]
	teams.append(data["team1"])
	teams.append(data["team2"])
	
func format_save():
	var data = {
		"season" = season,
		"round" = round,
		"team1" = teams[0],
		"team2" = teams[1],
	}
	return data

func has_team(t: Team): return teams.has(t)
	
