extends Control

func _ready():
	Main.main_node = self
	NodeUtil.remove_children(self)
	Main.emit_scene(Main.Scene.MainMenu)
	
