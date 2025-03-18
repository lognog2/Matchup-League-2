class_name TeamView extends Menu

@export var name_label: Label
@export var info_box: VBoxContainer
@export var sched_box: VBoxContainer
@export var fc_box: HBoxContainer
@export var color_rect: ColorRect

var team: Team

func _ready():
	scene_name = Main.Scene.TeamView
	
func render(t: Team):
	team = t
	name_label.text = team.name
	color_rect.color = team.color
	fill_info(team.format_info())
	fill_sched(team.schedule)
	fill_fighters(team.fighters)

func fill_info(info: Dictionary):
	var blank_label = NodeUtil.detach_child(info_box)
	for key in info:
		var new_label = blank_label.duplicate()
		new_label.text = "%s: %s" % [key, info[key]]
		info_box.add_child(new_label)

func fill_sched(sched: Dictionary):
	var blank_label = NodeUtil.detach_child(sched_box)
	for i in range (1, sched.size() + 1):
		var new_label = blank_label.duplicate()
		new_label.text = "%d) vs %s" % [i, team.get_opponent_name(i)]
		sched_box.add_child(new_label)

func fill_fighters(fighters: Array):
	NodeUtil.list_fighter_cards(fc_box, fighters)
