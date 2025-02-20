extends Control

@export var name_label: Label
@export var info_box: VBoxContainer
@export var sched_box: VBoxContainer
@export var fc_box: HBoxContainer

var team: Team

func _ready():
	pass
	
func render(t: Team):
	team = t
	name_label.text = team.name
	fill_info(team.format_info())
	fill_sched(team.sched)

func fill_info(info: Dictionary):
	var blank_label = info_box.get_child(0)
	blank_label.visible = false
	for key in info:
		var new_label = blank_label.duplicate()
		new_label.text = "%s: %s" % [key, info["key"]]
		info_box.add_child(new_label)

func fill_sched(sched: Dictionary):
	var blank_label = sched_box.get_child(0)
	blank_label.visible = false
	for r in sched:
		var new_label = blank_label.duplicate()
		new_label.text = "vs %s" % team.level.get_team(sched[r])
		sched_box.add_child(new_label)
