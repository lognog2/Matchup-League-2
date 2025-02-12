extends HBoxContainer

var main = preload("res://main/main.gd")
var level: Level
const no_id = "-1"

@export var id: LineEdit
@export var t_name: LineEdit
@export var color: ColorPickerButton

func _ready():
	level = main.getLevel("Prep")

func save():
	if (id.text == ""): id.text = no_id
	if (t_name.text == ""): return
	var data = {
		"id": id.text,
		"name": t_name.text,
		"season": main.getSeason(),
		"level": level.name,
		"color": color.color.to_rgba32()
	}
	var newID
	if (id.text == no_id):
		newID = level.addNewTeam(data)
	else:
		newID = level.setTeam(data)
	id.text = str(newID)

func load(t: Team):
	id.text = str(t.id)
	t_name.text = t.name
	color.color = Color.hex(t.color)
