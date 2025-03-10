extends VBoxContainer

@export var played: HBoxContainer
@export var bench: HBoxContainer

var team: Team
var blank_fc: FighterCard

func _ready():
	#SignalBus.user_select_fighter.connect(play_fighter)
	pass
	
func render(t: Team):
	blank_fc = NodeUtil.detach_child(played)
	team = t
	fill_bench(team.fighters)

func fill_bench(fighters: Array):
	NodeUtil.list_fighter_cards(bench, fighters)
	set_click_enable(!team.is_cpu)

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
	for fc in bench.get_children():
		fc.enable_click = enable
