extends Menu

@export var team_view: TeamView
@export var games_box: VBoxContainer
@export var ranking_box: VBoxContainer
@export var opp_rect: ColorRect
@export var opp_name_label: Label
@export var view_opp_button: Button
@export var next_game_button: Button

func _ready():
	pass

func render():
	team_view.fc_box.visible = true

func fill_games():
	var blank_game_card = NodeUtil.detach_child(games_box)
