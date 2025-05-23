extends Menu

@export var team_option: OptionButton
@export var team_view: TeamView
@export var name_entry: LineEdit

var team: Team

func _ready():
	SignalBus.to_career_select.connect(render)

func render(t: Team = null):
	if (!t):
		t =  Main.Levels.Prep.random_team_exclude(team)
	team = t
	team_option.clear()
	var select = 0
	team_option.add_item(Main.Keyname.Spectate)
	for t_name in team.level.get_t_names():
		team_option.add_item(t_name)
		if (t_name == team.de_name):
			select = team_option.item_count - 1
	team_option.selected = select
	team_view.render(team)

func _select(idx: int):
	if (idx == 0):
		team = null
		team_view.render_spectator()
		return
	var new_name = team_option.get_item_text(idx)
	var new_team = level.find_team(new_name)
	render(new_team)

func _random():
	render()

func _start():
	var p_name = name_entry.text if (!name_entry.text.is_empty()) else "User"
	Main.current_career = Career.create(level, p_name, team.id if (team) else -1)
	Main.current_career.begin_round()
	Main.emit_scene(Main.Scene.SeasonMenu, Main.main_node.user_confirm)
