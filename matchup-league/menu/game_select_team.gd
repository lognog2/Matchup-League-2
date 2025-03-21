extends VBoxContainer

@export var team_option: OptionButton
@export var team_view: Control
@export var cpu_check: CheckButton

var team: Team

func _ready():
	pass

func render(t: Team = null):
	cpu_check.button_pressed = true
	if (!t):
		t =  Main.Levels.Prep.random_team(Filter.exclude_self(team))
	team = t
	team_option.clear()
	var select = 0
	for t_name in team.level.get_t_names():
		team_option.add_item(t_name)
		if (t_name == team.name):
			select = team_option.item_count - 1
	team_option.selected = select
	team_view.render(team)

func _select(idx: int):
	var new_name = team_option.get_item_text(idx)
	var new_team = team.level.find_team(new_name)
	render(new_team)

func _random():
	render()

func is_cpu() -> bool:
	return cpu_check.button_pressed
