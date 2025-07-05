class_name TeamView extends Menu

@export var name_label: Label
@export var info_box: VBoxContainer
@export var sched_box: VBoxContainer
@export var fc_box: HBoxContainer
@export var color_rect: ColorRect
@export var breakdown_button: Button

var team: Team

func _ready():
	scene_name = Main.Scene.TeamView
	
func render(t: Team):
	if (!t):
		render_spectator()
		return
	team = t
	name_label.text = team.str_rank_name()
	color_rect.color = team.color
	breakdown_button.visible = true
	fill_info(team.format_info())
	fill_sched(team.schedule)
	fill_fighters(team.fighters)

func render_spectator():
	name_label.text = Main.Keyname.Spectate
	color_rect.color = Career.SPECTATOR_COLOR
	info_box.visible = false
	sched_box.visible = false
	fc_box.visible = false
	breakdown_button.visible = false

func fill_info(info: Dictionary):
	info_box.visible = true
	var blank_label = NodeUtil.detach_child(info_box)
	for key in info:
		var new_label = blank_label.duplicate()
		new_label.text = "%s: %s" % [key, info[key]]
		info_box.add_child(new_label)

func fill_sched(sched: Dictionary):
	sched_box.visible = true
	var blank_label = NodeUtil.detach_child(sched_box)
	var rounds = sched.keys()
	rounds.sort()
	for r in rounds:
		var new_label = blank_label.duplicate()
		new_label.text = team.str_game(r, true)
		sched_box.add_child(new_label)

func fill_fighters(fighters: Array):
	fc_box.visible = true
	NodeUtil.list_fighter_cards(fc_box, fighters)

func _click_breakdown():
	SignalBus.get_rating_breakdown.emit(team.rating_scale_breakdown())

func exit_breakdown():
	SignalBus.get_rating_breakdown.emit({})
