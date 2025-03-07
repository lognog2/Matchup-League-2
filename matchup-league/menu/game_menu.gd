extends Menu

@export var team_box: Container
var tb_arr = []

var game: Game

func _ready():
	SignalBus.play_game.connect(render)
	var new_team_box = team_box.duplicate()
	team_box.add_sibling(new_team_box)
	tb_arr = [team_box, new_team_box]

func render(g: Game):
	if (!g): Err.alert_fatal("No game specified for game menu", Err.Fatal.Runtime)
	elif (g.is_bye()): Err.alert_fatal("Cannot show bye in game menu", Err.Fatal.Invalid)
	set_team(0, g.teams[0])
	set_team(1, g.teams[1])

func set_team(i: int, t: Team):
	tb_arr[i].render(t)
