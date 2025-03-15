extends Menu

func to_freeplay():
	Main.emit_scene(Main.Scene.Freeplay)
	SignalBus.to_game_select.emit(null)

func to_editor():
	Main.emit_scene(Main.Scene.Editor)

func to_career():
	pass
