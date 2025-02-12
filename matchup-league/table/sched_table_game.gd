extends OptionButton

var main = preload("res://main/main.gd")

var level: Level
var teamID = -1
var opponentID = -1
var gameRound = -1
var game: Game

func _ready():
	level = main.getLevel("Prep")
	pass
	
func render(lvl: Level, team: Team, r: int):
	level = lvl
	teamID = team.id
	gameRound = r

func loadTeam(opponent: Team = null):
	if (!opponent): return
	opponentID = opponent.id
	add_item(opponent.name)
	selected = 0

func openTeamList():
	for t in level.getTeamsSorted():
		if (t.schedule[gameRound] == -1 && t.id != teamID):
			add_item(t.name)

func closeTeamList():
	opponentID = level.teamDict.find_key(get_item_text(selected))
	clear()
	if (opponentID): add_item(level.teamDict[opponentID].name)
	selected = 0

	
	
