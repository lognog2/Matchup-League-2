class_name GameCard extends Card

@export var teams_box: VBoxContainer
@export var scores_box: VBoxContainer
@export var done_button: Button

var game: Game
var team_labels = []
var score_labels = []

func _ready():
	pass

func render(g: Game = null):
	if (g):
		game = g
	render_teams()
	#implement for dramatic reveal
	#if (game.is_finished()):
	#	scores_box.visible = false
	#else:
	render_scores()
  
func render_teams():
	var blank_team_label = NodeUtil.detach_child(teams_box)
	team_labels = [blank_team_label, blank_team_label.duplicate()]
	for i in range (team_labels.size()):
		team_labels[i].text = game.teams[i].str_rank_name()
		teams_box.add_child(team_labels[i])

func render_scores():
	done_button.visible = false
	var blank_score_label = NodeUtil.detach_child(scores_box)
	score_labels = [blank_score_label, blank_score_label.duplicate()]
	for i in range (team_labels.size()):
		score_labels[i].text = str(game.score[i])
		scores_box.add_child(score_labels[i])
	scores_box.visible = true

## actions taken after using context menu
func _show_game(idx: int):
	if (idx == 0):
		Main.emit_scene(Main.Scene.GameMenu)
		Stream.cache(func(): SignalBus.play_game.emit(game, true))
	elif (idx == 1):
		render_scores()
	else:
		Err.alert_warn("Unsupported index %d" % idx, Err.Warn.NoAction)




	
