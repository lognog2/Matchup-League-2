extends Control

@export var team_cont: Container

var tc_arr = []

func _ready():
	var new_team_cont = team_cont.duplicate()
	team_cont.add_sibling(new_team_cont)
	tc_arr = [team_cont, new_team_cont]
	SignalBus.do_game.connect(set_teams)

func set_teams(t1: Team, t2: Team):
	set_team(0, t1)
	set_team(1, t2)

func set_team(i: int, t: Team):
	tc_arr[i].render(t)

func _back():
	Main.emit_scene()

func _game():
	pass
	#Main.emit_scene(Main.Scene.Game)
