extends Menu

@export var team_view: TeamView
@export var games_box: VBoxContainer
@export var ranking_box: VBoxContainer
@export var opp_rect: ColorRect
@export var round_label: Label
@export var next_game_label: Label
@export var opp_name_label: Label
@export var result_label: Label
@export var view_opp_button: Button
@export var next_game_button: Button
@export var next_round_button: Button
@export var sim_round_button: Button

var career: Career
var team: Team
var opp: Team
var rnd = 0

func _ready():
	render()

func render(before = true):
	career = Main.current_career
	team = career.get_team()
	rnd = career.current_round
	round_label.text = "Round %d" % rnd
	team_view.render(team)
	team_view.fc_box.visible = false #must be after render
	fill_opp_info(before)
	fill_rankings()
	fill_games()

func fill_opp_info(before = true):
	if (career.is_spectator()): 
		fill_opp_null(before)
		return
	opp = team.get_opponent(career.current_round)
	if (!opp): 
		fill_opp_null(before)
		return
	opp_rect.color = opp.color
	opp_name_label.text = opp.rank_name(true)
	next_game_label.text = "Next game:" if (before) else "Game vs:"
	view_opp_button.visible = true
	next_game_button.visible = before
	next_round_button.visible = !before
	sim_round_button.visible = false
	result_label.text = team.game_str(rnd, false)

func fill_opp_null(before = true):
	opp_name_label.text = "No game this round"
	opp_rect.color = Color.DARK_GRAY
	next_game_label.text = " "
	view_opp_button.visible = false
	next_game_button.visible = false
	sim_round_button.visible = before
	next_round_button.visible = !before
	result_label.visible = false

func fill_rankings():
	var blank_team_label = NodeUtil.detach_child(ranking_box)
	var teams_ranked = level.set_rankings()
	for t in teams_ranked:
		var tl = blank_team_label.duplicate()
		tl.text = t.rank_name()
		ranking_box.add_child(tl)

func fill_games():
	var blank_game_card = NodeUtil.detach_child(games_box)
	var current_games = level.get_current_games(rnd)
	for g in current_games:
		var gc = blank_game_card.duplicate()
		gc.render(g)
		games_box.add_child(gc)

func _view_opp():
	Main.emit_scene(Main.Scene.TeamMenu)
	SignalBus.to_team_menu.emit(opp)

func _next_game():
	pass

func _next_round():
	pass
