extends "res://table/sched_table.gd"

@onready var nameLabel = $hbox/vbox/name
@onready var game = $hbox/vbox/game
@onready var box = $hbox/vbox

var team: Team
var level: Level

const numGames = 7

func _ready():
	game.visible = false
	
func getGame(r: int): return box.get_child(r + 1)	

func setTeam(t: Team):
	team = t
	nameLabel.text = t.name
	self.color = Color.hex(t.color)
	level = t.level
	for i in range(numGames):
		var newGame = game.duplicate()
		box.add_child(newGame)
		newGame.render(level, team, i)
		newGame.visible = true
	visible = true

func save():
	var games = box.get_children()
	for i in range (2, box.get_child_count()):
		team.schedule[i] = games[i].opponentID
	print("save")
	
