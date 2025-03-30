extends VBoxContainer

@export var played: HBoxContainer
@export var bench: HBoxContainer
@export var team_name_label: Label

# left panel
@export var score_label: Label
@export var result_button: Button
@export var scoreboard_color_rect: ColorRect

#right panel
@export var result_panel: Container
@export var right_panel_rect: ColorRect
@export var result_label: Label
@export var return_button: Button

var i = -1
var team: Team
var blank_fc: FighterCard

func _ready():
	#SignalBus.user_select_fighter.connect(play_fighter)
	pass
	
func render(idx: int, t: Team):
	i = idx
	team = t
	blank_fc = NodeUtil.detach_child(played)
	fill_bench(team.fighters)
	set_score(0)
	result_button.visible = false
	scoreboard_color_rect.color = team.color
	team_name_label.text = team.de_name
	result_panel.visible = false

func fill_bench(fighters: Array):
	NodeUtil.list_fighter_cards(bench, fighters)
	set_click_enable(!team.cpu)

func set_score(score: int):
	score_label.text = str(score)

func add_to_played(fc: FighterCard):
	if (!fc): 
		Err.print_warn("no fighter selected", Err.Warn.NoAction)
		return
	var new = blank_fc.duplicate()
	new.render(fc.fighter)
	played.add_child(new)
	bench.remove_child(fc)

func play_fighter(fc: FighterCard = null):
	if (!team.cpu):
		if (fc.fighter.team == team):
			add_to_played(fc)
			set_click_enable(false)
	elif (fc):
		add_to_played(fc)
	else:
		add_to_played(bench.get_children().pick_random())

## disabled after user selects a fighter, enabled again after opponent does
func set_click_enable(enable = true):
	if (!team.cpu):
		for fc in bench.get_children():
			fc.enable_click = enable

func show_right_panel(is_tie = false):
	set_click_enable(false)
	result_panel.reparent(played)
	played.add_child(result_panel)
	if (is_tie):
		result_label.text = "It's a tie"
		right_panel_rect.color = played.get_child(0).ResultColor.Tie
	else:
		result_label.text = "%s wins!" % team.de_name
		right_panel_rect.color = team.color
	played.move_child(result_panel, -1)
	result_panel.visible = true

func can_play() -> bool:
	return played.get_child_count() < team.level.FPG || bench.get_child_count() > 0
	
	
