extends Control

func exit_season():
	Main.load_state()

func _home():
	Main.emit_scene(Main.Scene.SeasonMenu)
	
func _team_menu():
	var team = Main.current_career.get_team()
	Main.emit_scene(Main.Scene.TeamMenu)
	SignalBus.to_team_menu.emit(team)
	
func _main_menu():
	exit_season()
	Main.emit_scene(Main.Scene.MainMenu)
