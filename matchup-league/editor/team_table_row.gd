extends "res://editor/team_table.gd"

var team: Team
const no_id = "-1"

@export var id: LineEdit
@export var t_name: LineEdit
@export var color: ColorPickerButton
@export var series: LineEdit

func _enter_tree():
	pass

func save():
	if (id.text == ""): id.text = no_id
	if (t_name.text == ""): return
	var data = {
		"id": id.text,
		"name": t_name.text,
		"season": Main.get_season(),
		"level name": Main.Levels.Pro.get_name(),
		"color": color.color.to_rgba32(),
		"schedule": team.schedule if (team && team.schedule) else {},
		"series": series.text
	}
	var new_team
	if (id.text == no_id || !level.has_team_id(int(id.text))):
		new_team = level.add_team(data)
	else:
		new_team = level.set_team(data)
	id.text = str(new_team.id)

func load(t: Team):
	team = t
	id.text = str(t.id)
	t_name.text = t.de_name
	color.color = t.color
	level = t.level
	series.text = t.series
