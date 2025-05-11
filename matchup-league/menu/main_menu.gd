extends Menu

func to_freeplay():
	Main.emit_scene(Main.Scene.GameSelect)
	Stream.cache(func(): SignalBus.to_game_select.emit(null))
	
func to_career():
	Main.emit_scene(Main.Scene.CareerSelect)
	Stream.cache(func(): SignalBus.to_career_select.emit())
	
func load_career():
	Main.emit_scene(Main.Scene.LoadCareer)

func to_editor():
	Main.emit_scene(Main.Scene.Editor)
