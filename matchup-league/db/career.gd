class_name Career extends Node

const DEFAULT_NAME = "default"
static var FILE_NAME = "career.save"

var current_round = 0
var user_player: Player

static func create(level: Level, car_name: String, team_id = -1) -> Career:
	var data = {
		"name" = car_name,
		"team ID" = team_id
	}
	var user = level.add_player(data)
	return Career.new(user)

func _init(user: Player):
	user_player = user

func get_team() -> Team:
	return user_player.team

func set_team(team: Team):
	user_player.set_team(team)

func get_level() -> Level:
	return Main.Levels.Prep

func name() -> String:
	return user_player.name()

func is_spectator() -> bool:
	return (!get_team())
	
func begin_round():
	user_player.connect_objs()
	current_round += 1
	if (current_round < 1):
		Err.print_fatal("career.begin_round() can only be used in positive rounds", Err.Fatal.Conflict)
		return
	get_level().set_rankings()
	#Main.save_state(false)
	
func sim_round():
	get_level().sim_round(current_round)

func is_before_rnd() -> bool:
	var t: Team
	if (is_spectator()):
		t = get_level().get_team()
	else:
		t = get_team()
	return !(t.get_game(current_round).is_finished())

func format_info() -> Dictionary:
	return {
		name = name(),
		round = current_round,
		team = get_team(),
		season = Main.get_season()
	}

func format_save() -> Dictionary:
	var has_team = (get_team() != null)
	var color = Main.format_color_hex(get_team().color) if (has_team) else Main.format_color_hex(Color.DARK_GRAY)
	return {
		name = name(),
		round = current_round,
		team_name = get_team().name() if (has_team) else Main.Keyname.Spectate,
		team_id = get_team().id if (has_team) else -1,
		color = color,
		season = Main.get_season(),
		seed = Main.game_seed,
		level = user_player.level.name
	}
