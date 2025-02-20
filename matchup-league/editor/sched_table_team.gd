extends "res://editor/sched_table.gd"

@onready var vbox = $inner_mpane/info_vbox
@onready var name_label = $inner_mpane/info_vbox/name
@onready var blank_game = $inner_mpane/info_vbox/game

var team: Team

const numGames = 7

func _ready():
	blank_game.visible = false

func get_game(r: int): 
	return vbox.get_child(r)

func set_game(r: int, opp: Team):
	var game = get_game(r)
	if (opp):
		game.set_oppID(opp.id)
	else: 
		game.set_oppID(-1, false)

func set_team(t: Team):
	team = t
	name_label.text = t.name
	self.color = Color.hex(t.color)
	level = t.level
	for i in range(1, numGames + 1):
		var newGame = blank_game.duplicate()
		vbox.add_child(newGame)
		newGame.render_game(i, t, vbox.get_child(-1))
		newGame.visible = true
		if (!team.check_sync(i)): print(team.name, i)
	blank_game.queue_free()
	visible = true
	add_to_group(TEAM_GROUP)

## @deprecated: dont use
func save():
	var games = vbox.get_children()
	for i in range (1, vbox.get_child_count()):
		var oppID = games[i].opponentID
		if (team.get_opponent(i) != oppID):
			print("/ " + str(team.id) + " vs " + str(oppID))
			team.add_game(i, oppID)
