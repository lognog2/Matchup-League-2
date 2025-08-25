class_name Career extends Object

const DEFAULT_NAME = "default"

const FILE_FORMAT = "career%s.save"
static var FILE_NAME = FILE_FORMAT % ""
static var FILE_BACKUP = FILE_FORMAT % FileUtil.BACKUP_EXT
static var SPECTATOR_COLOR = Color8(41, 41, 41)

var current_round: Variant = 0
var user_player: Player

static func create(level_name: String, car_name: String, team_id = -1) -> Career:
	var data = {
		"level name" = level_name,
		"name" = car_name,
		"team ID" = team_id
	}
	var user = Player.new(data)
	return Career.new(user)

func _init(user: Player):
	user_player = user

func get_team() -> Team:
	return user_player.team

func set_team(team: Team):
	user_player.set_team(team)

func get_level() -> Level:
	return user_player.level
	
func get_tournament() -> Tournament:
	if (!in_tourney()): return null
	return get_level().get_tournament(current_round[0])

func name() -> String:
	return user_player.name()

func is_spectator() -> bool:
	return (!get_team())

func in_tourney() -> bool:
	return (current_round is Array)
	
## advances regular season round, emits next_round signal
func begin_round():
	
	if (in_tourney()):
		var tourney = get_tournament()
		tourney.advance()
		if (tourney.is_done()):
			end()
		else:
			current_round = tourney.tourney_key()
	elif (current_round == Main.season_length):
		get_level().begin_playoff()
	else:
		user_player.connect_objs()
		current_round += 1
		get_level().set_rankings()
		
	Err.print("/ begin round %s" % str(current_round))
	SignalBus.next_round.emit(current_round)
	
func sim_round():
	get_level().sim_round(current_round)

func has_current_round() -> bool:
	return current_round != null

func is_before_rnd() -> bool:
	var t = get_team()
	if (is_spectator() || !t.has_game(current_round)):
		var filter = func(tm: Team): return tm.has_game(current_round)
		t = get_level().get_teams_limited(filter, 1).pop_front()
	if (!t): return true
	return !(t.get_game(current_round).is_finished())

func career_file_path(backup = false) -> String:
	var file_name = FILE_BACKUP if (backup) else FILE_NAME
	var path = FileUtil.save_path + "/" + file_name
	return path

func end():
	current_round = null

func save(backup = false):
	var paths = [career_file_path(false)]
	if (backup):
		paths.append(career_file_path(true))
	for path in paths:
		FileUtil.write_to_file(format_save(), path)

func format_info() -> Dictionary:
	return {
		name = name(),
		round = current_round,
		team = get_team(),
		season = Main.get_season()
	}

func format_save() -> Dictionary:
	var has_team = (get_team() != null)
	var color = Main.format_color_hex(get_team().color) if (has_team) else Main.format_color_hex(SPECTATOR_COLOR)
	return {
		"name" = name(),
		"round" = current_round,
		"team_name" = get_team().name() if (has_team) else Main.Keyname.Spectate,
		"team_id" = get_team().id if (has_team) else -1,
		"color" = color,
		"season" = Main.get_season(),
		"level name" = user_player.level.name
	}
