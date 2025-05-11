extends Card

@export var name_label: Label
@export var round_label: Label
@export var season_label: Label
@export var team_label: Label
@export var team_rect: ColorRect

var career_name: String

func _render(data: Dictionary):
	career_name = data.name
	fill_card(data)
	visible = true

func fill_card(data: Dictionary):
	name_label.text = data.name
	round_label.text = "Round %d" % data.round
	season_label.text = "Season %d" % data.season
	team_label.text = data.team_name
	team_rect.color = data.team_color

func _select():
	Main.load_data(career_name)
