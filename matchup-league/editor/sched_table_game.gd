extends "res://editor/sched_table_team.gd"

var button: OptionButton
var opponentID = -1
var gameRound = 0
var game: Game

func _enter_tree():
	pass

func render_game(r: int, t: Team, ob: OptionButton):
	gameRound = r
	team = t
	button = ob
	set_level()
	if (t.has_game(r)): 
		set_oppID(t.get_opponent(r).id, false)

func signal_oppID(index: int):
	var t_name = button.get_item_text(button.selected)
	#print("signal oppID " + t_name)
	var opp = level.find_team(t_name)
	if (!opp): #remove opponent
		var old_opp = level.get_team(opponentID)
		set_oppID(-1, true)
		SignalBus.user_set_game.emit(gameRound, old_opp, null)
	elif (index >= -1): #set opponent
		set_oppID(opp.id, true)
		SignalBus.user_set_game.emit(gameRound, opp, team)
	else: 
		print("? how did you get here")

func set_oppID(id: int, setGames = false):
	#print("/ set oppID " + str(team.id) + " " + str(id) + " " + str(setGames))
	opponentID = id
	closeTeamList()
	if (setGames):
		print("/ setting game but not really")
		#team.add_game(gameRound, opponentID)

func openTeamList():
	button.clear()
	button.add_item(Main.Keyname.Empty)
	var empty_game_filter = (func (t: Team): if (!t.has_game(gameRound) && t.id != team.id): return true)
	for t_name in level.get_t_names(empty_game_filter):
		button.add_item(t_name)
	button.add_item(Main.Keyname.Remove)
	
func closeTeamList():
	hide()
	show()
	button.clear()
	if (opponentID >= 0):
		button.add_item(level.get_team(opponentID).de_name)
		button.selected = 0
	else:
		team.remove_game(gameRound)
		button.selected = -1
