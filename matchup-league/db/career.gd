class_name Career extends Node

var current_round = 0
var user_player: Player

func _init(user: Player):
	user_player = user

func get_team() -> Team:
	return user_player.team

func get_level() -> Level:
	return Main.Levels.Prep

func is_spectator() -> bool:
	return (!get_team())
	
func begin_round():
	current_round += 1
	if (current_round < 1):
		Err.print_fatal("career.begin_round() can only be used in positive rounds", Err.Fatal.Conflict)
		return
	get_level().set_rankings()
	
func sim_round():
	get_level().sim_round(current_round)

func is_before_rnd() -> bool:
	var t: Team
	if (is_spectator()):
		t = get_level().get_team()
	else:
		t = get_team()
	return !(t.get_game(current_round).is_finished())
