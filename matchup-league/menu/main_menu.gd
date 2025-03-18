extends Menu

func to_freeplay():
	Main.emit_scene(Main.Scene.Freeplay)
	SignalBus.to_game_select.emit(null)
	
func to_career():
	Main.emit_scene(Main.Scene.CareerSelect)
	SignalBus.to_career_select.emit()

func to_editor():
	Main.emit_scene(Main.Scene.Editor)
