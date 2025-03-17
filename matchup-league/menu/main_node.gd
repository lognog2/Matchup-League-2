extends Menu

@export var vbox: VBoxContainer
@export var version_label: Label

func _ready():
	Main.main_node = self
	version_label.text = Main.version_edition
	Main.emit_scene(Main.Scene.MainMenu)

func set_scene(scene: Variant):
	vbox.get_child(0).queue_free()
	vbox.add_child(scene)
	vbox.move_child(scene, 0)
	scene.size_flags_vertical = SIZE_EXPAND_FILL
