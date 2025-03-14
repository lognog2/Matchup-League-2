extends Menu

@export var team_box: Container
var tb_arr = [] ## 0 on top, 1 on bottom

var game: Game

var current_mode
enum Mode {
	BothUser,
	UserCpu,
	BothCpu,
}


func _ready():
	SignalBus.user_select_fighter.connect(play_fighter)
	SignalBus.play_game.connect(render)
	var new_team_box = team_box.duplicate()
	NodeUtil.reverse_children(team_box)
	team_box.add_sibling(new_team_box)
	tb_arr = [team_box, new_team_box]
   
func render(g: Game):
	if (!g): Err.alert_fatal("No game specified for game menu", Err.Fatal.Runtime)
	elif (g.is_bye()): Err.alert_fatal("Cannot show bye in game menu", Err.Fatal.Invalid)
	game = g
	set_team(0, game.teams[0])
	set_team(1, game.teams[1])
	set_mode()

func set_team(i: int, t: Team):
	tb_arr[i].render(i, t)

func set_mode():
	match [game.teams[0].is_cpu, game.teams[1].is_cpu]:
		[false, false]:
			current_mode = Mode.BothUser
		[true, false]:
			current_mode = Mode.UserCpu
		[false, true]:
			reverse_sides()
			current_mode = Mode.UserCpu
		[true, true]:
			current_mode = Mode.BothCpu

func reverse_sides():
	NodeUtil.reverse_children(tb_arr[0].get_parent(), 1)
	var temp = tb_arr[0]
	tb_arr[0] = tb_arr[1]
	tb_arr[1] = temp

func play_fighter(fc: FighterCard = null):
	if (!fc):
		#mode: both cpu
		tb_arr[0].play_fighter()
		tb_arr[1].play_fighter()
	match current_mode:
		Mode.BothUser:
			#faster to send it to both than check if needed beforehand
			tb_arr[0].play_fighter(fc)
			tb_arr[1].play_fighter(fc)
			if (tb_arr[0].played.get_child_count() == tb_arr[1].played.get_child_count()):
				start_match()
		Mode.UserCpu:
			tb_arr[0].play_fighter()
			tb_arr[1].play_fighter(fc)

func start_match():
	var fcs = [tb_arr[0].played.get_child(-1), tb_arr[1].played.get_child(-1)]
	var m = game.run_match(fcs[0], fcs[1])
	var r = m.result
	if (r == -1):
		fcs[0].render_tie(m.ModApplied.str1, m.ModApplied.wk1)
		fcs[1].render_tie(m.ModApplied.str2, m.ModApplied.wk2)
	elif (r == 0):
		fcs[0].render_win(m.ModApplied.str1, m.ModApplied.wk1)
		fcs[1].render_loss(m.ModApplied.str2, m.ModApplied.wk2)
	elif (r == 1):
		fcs[0].render_loss(m.ModApplied.str1, m.ModApplied.wk1)
		fcs[1].render_win(m.ModApplied.str2, m.ModApplied.wk2)
	else:
		Err.alert_fatal("Invalid match result", Err.Fatal.Invalid)

	for i in range (tb_arr.size()):
		tb_arr[i].set_score(game.score[i])
