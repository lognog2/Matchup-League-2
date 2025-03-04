extends "res://editor/sched_table.gd"

@export var vbox: VBoxContainer
@export var name_label: Label
@export var blank_game: OptionButton

var team: Team

const numGames = 7

func _enter_tree():
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
	self.color = t.color
	level = t.level
	for i in range(1, numGames + 1):
		var newGame = blank_game.duplicate()
		vbox.add_child(newGame)
		newGame.render_game(i, t, vbox.get_child(-1))
		newGame.visible = true
	blank_game.queue_free()
	visible = true
	add_to_group(TEAM_GROUP)

## @deprecated: dont use
func save():
	var games = vbox.get_children()
	for i in range (1, vbox.get_child_count()):
		var oppID = games[i].opponentID
		if (team.get_opponent(i).id != oppID):
			print("/ " + str(team.id) + " vs " + str(oppID) + " but not really")
			#team.add_game(i, oppID)
