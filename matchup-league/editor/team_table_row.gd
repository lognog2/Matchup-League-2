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
	if (!team || t_name.text == ""): return
	var data = {
		"id": id.text,
		"name": t_name.text,
		"season": Main.get_season(),
		"level name": level.name,
		"color": color.color.to_rgba32(),
		"schedule": team.schedule if (team.schedule) else {},
		"series": series.text
	}
	var newID
	if (id.text == no_id):
		newID = level.add_team(data)
	else:
		newID = level.set_team(data)
	id.text = str(newID)

func load(t: Team):
	team = t
	id.text = str(t.id)
	t_name.text = t.name
	color.color = t.color
	level = t.level
