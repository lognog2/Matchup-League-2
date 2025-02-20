extends HBoxContainer

var main = preload("res://main/main.gd")
var level: Level
var team: Team
const no_id = "-1"

@export var id: LineEdit
@export var t_name: LineEdit
@export var color: ColorPickerButton

func _ready():
	level = main.getLevel("Prep")

func save():
	if (id.text == ""): id.text = no_id
	if (!team || t_name.text == ""): return
	var data = {
		"id": id.text,
		"name": t_name.text,
		"season": main.getSeason(),
		"level": level.name,
		"color": color.color.to_rgba32(),
		"schedule": team.schedule || {}
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
	color.color = Color.hex(t.color)
