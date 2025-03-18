extends Menu

@export var team_option: OptionButton
@export var team_view: Control

var player: Player
var team: Team

func _ready():
	SignalBus.to_career_select.connect(render)

func render(t: Team = null):
	if (!t):
		t =  Main.Levels.Prep.random_team(Filter.exclude_self(team))
	team = t
	team_option.clear()
	var select = 0
	team_option.add_item(Main.Keyname.Spectate)
	for t_name in team.level.get_t_names():
		team_option.add_item(t_name)
		if (t_name == team.name):
			select = team_option.item_count - 2
	team_option.selected = select
	team_view.render(team)

func _select(idx: int):
	var new_name = team_option.get_item_text(idx)
	var new_team = team.level.find_team(new_name)
	render(new_team)

func _random():
	render()

func _back():
	Main.emit_scene()

func _play():
	Main.emit_scene(Main.Scene.SeasonMenu)

func set_game():
	var data = {
	}
	player = Main.Levels.Prep.add_player(data)
