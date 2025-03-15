extends VBoxContainer

@export var played: HBoxContainer
@export var bench: HBoxContainer
@export var score_label: Label
@export var result_button: Button
@export var scoreboard_color_rect: ColorRect

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

func fill_bench(fighters: Array):
	NodeUtil.list_fighter_cards(bench, fighters)
	set_click_enable(!team.is_cpu)

func set_score(score: int):
	score_label.text = str(score)

func add_to_played(fc: FighterCard):
	var new = blank_fc.duplicate()
	new.render(fc.fighter)
	played.add_child(new)
	bench.remove_child(fc)

func play_fighter(fc: FighterCard = null):
	if (!team.is_cpu):
		if (fc.fighter.team == team):
			add_to_played(fc)
			set_click_enable(false)
	elif (fc):
		add_to_played(fc)
	else:
		add_to_played(bench.get_children().pick_random())

## disabled after user selects a fighter, enabled again after opponent does
func set_click_enable(enable = true):
	if (!team.is_cpu):
		for fc in bench.get_children():
			fc.enable_click = enable
