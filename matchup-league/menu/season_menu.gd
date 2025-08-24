extends Menu

@export var team_view: TeamView
@export var games_box: VBoxContainer
@export var ranking_box: VBoxContainer
@export var fighters_box: VBoxContainer
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

var Text = {
	NextGame = "Play next game",
	NoGame = "No game this round",
	Round = "Round %d",
	SeasonEnd = "Season over",
	TourneyEnd = "The end",
}

func _ready():
	render()

func render():
	career = Main.current_career
	team = career.get_team()
	rnd = career.current_round
	round_label.visible = true
	round_label.text = Text.Round % Main.int_round(rnd)
	team_view.render(team)
	team_view.fc_box.visible = false #must be after render
	var before = career.is_before_rnd()
	fill_opp_info(before)
	if (before):
		level.set_rankings()
	else:
		career.sim_round()
	fill_rankings()
	fill_games()
	fill_fighters()

func fill_opp_info(before = true):
	next_round_button.visible = !before
	check_tourney(before)
	if (career.is_spectator()): 
		fill_opp_null(before)
		return
	opp = team.get_opponent(rnd)
	if (!opp): 
		fill_opp_null(before)
		return
	if (before && !career.has_current_round()):
		opp_rect.color = team.color
		fill_opp_end()
		return
	opp_rect.color = opp.color
	next_game_label.text = "Next game:" if (before) else "Game vs:"
	opp_name_label.text = opp.str_rank_name(true)
	view_opp_button.visible = true
	next_game_button.visible = before
	next_game_button.text = Text.NextGame
	sim_round_button.visible = false
	result_label.text = team.str_game(rnd, false)

func fill_opp_null(before = true):
	opp_rect.color = Career.SPECTATOR_COLOR
	opp_name_label.text = Text.NoGame
	result_label.visible = false
	view_opp_button.visible = false
	next_game_button.visible = false
	sim_round_button.visible = before
	if (!rnd): 
		fill_opp_end()
		return

func fill_opp_end():
	next_game_label.text = Text.TourneyEnd
	opp_name_label.text = ":)"
	round_label.visible = false
	view_opp_button.visible = false
	view_opp_button.visible = false
	sim_round_button.visible = false

func check_tourney(before: bool):
	if (end_of_season(before)):
		level.begin_playoff()

func end_of_season(before: bool) -> bool:
	if (!before || !rnd): return false
	return (!career.in_tourney() && (rnd > Main.season_length))

func fill_rankings():
	level.set_rankings()
	var blank_team_label = NodeUtil.detach_child(ranking_box)
	var teams_ranked = level.get_teams_filtered(Filter.Select.TeamRanked, Filter.Sort.TeamRank)
	for t in teams_ranked:
		var tl = blank_team_label.duplicate()
		tl.text = t.str_rank_name() + " " + t.str_record()
		ranking_box.add_child(tl)

func fill_games():
	var blank_game_card = NodeUtil.detach_child(games_box)
	var current_games = level.get_current_games(rnd)
	for g in current_games:
		var gc = blank_game_card.duplicate()
		gc.render(g)
		games_box.add_child(gc)

func fill_fighters():
	var blank_f_label = NodeUtil.detach_child(fighters_box)
	blank_f_label.visible = false
	var comp_filter = Filter.compound_sort([Filter.Compound.WinPct, Filter.Compound.Wins, Filter.Compound.Rating])
	var fighters_ranked = level.get_fighters_sorted(comp_filter, level.config.rank_amt)
	for i in range(fighters_ranked.size()):
		var new_label = blank_f_label.duplicate()
		new_label.text = "%2d " % (i + 1) + fighters_ranked[i].str_name_matches()
		new_label.visible = true
		fighters_box.add_child(new_label)

func _view_opp():
	Main.emit_scene(Main.Scene.TeamMenu)
	Stream.cache(func(): SignalBus.to_team_menu.emit(opp))

func _next_game():
	if (!team.has_game(rnd)):
		Err.alert_fatal("No playable game this round", Err.Fatal.Invalid)
		return
	Main.emit_scene(Main.Scene.GameSelect)
	Stream.cache(func(): SignalBus.to_game_select.emit(team.get_game(rnd)))
	
func _next_round():
	career.begin_round()
	render()

func _sim_round():
	career.sim_round()
	update_games()
	fill_opp_info(false)

## updates existing game cards, preserving the order
func update_games():
	for gc in games_box.get_children():
		gc.render()
