extends Menu

func exit_season():
	Main.load_state()

func _home():
	Main.emit_scene(Main.Scene.SeasonMenu)
	
func _team_menu():
	var team = Main.current_career.get_team()
	Main.emit_scene(Main.Scene.TeamMenu)
	Stream.cache(func(): SignalBus.to_team_menu.emit(team))
	
func _main_menu():
	Main.save_state(check_save_backup(Setting.SaveSpot.Main_menu))
	Stream.queue(func():
		exit_season()
		Main.emit_scene(Main.Scene.MainMenu)
		)
	
func _save():
	super._save()
	
func _settings():
	Main.emit_scene(Main.Scene.SettingsMenu)
