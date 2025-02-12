class_name Game extends DataEntity

var round: int
var team1 = {
	"id" = -1,
	"result" = 0,
	"score" = 0
}
var team2 = team1.duplicate()

func _init(data: Dictionary):
	super(data)
	round = data["round"]
	team1 = data["team1"]
	team2 = data["team2"]
	if (id < 0): id = (round * 1000000) + (team1.id * 1000) + team2.id
	
func format_save():
	var data = {
		"id" = id,
		"season" = season,
		"round" = round,
		"team1" = team1,
		"team2" = team2,
	}
	return data

func hasTeam(t: Team):
	return t.id == team1 || t.id == team2
	
