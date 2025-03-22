extends Menu

@export var team_box: Container
var tb_arr = [] ## 0 on top, 1 on bottom

var game: Game
var reversed = false
var replay: bool

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
   
func render(g: Game, rep = false):
	if (!g): Err.alert_fatal("No game specified for game menu", Err.Fatal.Runtime)
	elif (g.is_bye()): Err.alert_fatal("Cannot show bye in game menu", Err.Fatal.Invalid)
	game = g
	replay = rep
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
			show_result_button()

func reverse_sides():
	NodeUtil.reverse_children(tb_arr[0].get_parent(), 1)
	tb_arr.reverse()
	reversed = !reversed

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
				show_result_button()
		Mode.UserCpu:
			tb_arr[0].play_fighter()
			tb_arr[1].play_fighter(fc)
			show_result_button()

func show_result_button():
	tb_arr[1].result_button.visible = true

func hide_result_button():
	tb_arr[1].result_button.visible = false

func start_match():
	var both_cpu = (current_mode == Mode.BothCpu)
	if (both_cpu): play_fighter()
	var fcs = [tb_arr[0].played.get_child(-1), tb_arr[1].played.get_child(-1)]
	if (reversed): fcs.reverse()
	var m = game.run_match(fcs[0].fighter, fcs[1].fighter)
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
		var x = i
		if (reversed): x -= 1
		tb_arr[x].set_score(game.score[i])
		if (!tb_arr[x].can_play()):
			finish_game()
			return
		tb_arr[x].set_click_enable(true)

	if (!both_cpu):
		hide_result_button()

func finish_game():
	hide_result_button()
	game.set_result()
	var x = game.result
	if (x == -1):
		tb_arr[1].show_right_panel(true)
		return
	elif (reversed):
		x -= 1
	tb_arr[x].show_right_panel(
	)

func _return():
	if (game.is_official()):
		Main.emit_scene(Main.Scene.SeasonMenu)
	else:
		Main.emit_scene(Main.Scene.MainMenu)

#func adjust_result_reverse(r: int) -> int:
#	if (reversed):
#		if (r == 0): return 1
#		elif (r == 1): return 0
#	return r
