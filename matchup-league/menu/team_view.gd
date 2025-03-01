extends Menu

@export var name_label: Label
@export var info_box: VBoxContainer
@export var sched_box: VBoxContainer
@export var fc_box: HBoxContainer

var team: Team

func _ready():
	pass
	
func render(t: Team):
	scene_name = Main.Scene.TeamView
	team = t
	name_label.text = team.name
	fill_info(team.format_info())
	fill_sched(team.schedule)
	fill_fighters(team.fighters)

func fill_info(info: Dictionary):
	var blank_label = info_box.get_child(0).duplicate()
	info_box.get_children().clear()
	for key in info:
		var new_label = blank_label.duplicate()
		new_label.text = "%s: %s" % [key, info[key]]
		info_box.add_child(new_label)

func fill_sched(sched: Dictionary):
	var blank_label = sched_box.get_child(0).duplicate()
	sched_box.get_children().clear()
	for r in sched:
		var new_label = blank_label.duplicate()
		new_label.text = "%d. vs %s" % [r, team.get_opponent_name(r)]
		sched_box.add_child(new_label)

func fill_fighters(fighters: Array):
	var blank_fc = fc_box.get_child(0).duplicate()
	fc_box.get_children().clear()
	for f in fighters:
		var new_fc = blank_fc.duplicate()
		new_fc.render(f)
		fc_box.add_child(new_fc)
