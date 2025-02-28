extends Menu

func to_freeplay():
	Main.emit_scene(Main.Scene.Freeplay)
	SignalBus.do_game.emit(null, null)

func to_editor():
	Main.emit_scene(Main.Scene.Editor)

func to_career():
	pass
