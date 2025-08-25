class_name CareerCard extends Card

@export var name_label: Label
@export var round_label: Label
@export var season_label: Label
@export var team_label: Label
@export var team_rect: ColorRect

var career_name: String
var data: Dictionary
var timestamp: int ##unix time

func render(dat: Dictionary):
	data = dat
	fill_card()
	visible = true

func fill_card():
	name_label.text = data.name
	round_label.text = "Round %s" % str(data.round) if data.round else "Completed"
	season_label.text = "Season %d" % data.season
	team_label.text = data.team_name
	team_rect.color = Main.format_color(data.color)
	timestamp = data.timestamp

func _select():
	Main.load_state(data)
	Main.emit_scene(Main.Scene.SeasonMenu)
