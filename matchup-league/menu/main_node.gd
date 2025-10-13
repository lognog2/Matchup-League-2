extends Control

@export var root_container: Container
@export var vbox: VBoxContainer
@export var version_label: Label
@export var seed_label: Label
@export var save_box: Container

const save_hide_delay = 0.5 ## in seconds

func _ready():
	#print("root")
	#SignalBus.done_saving.connect(save_game_end)
	Main.main_node = self
	save_box.visible = false
	version_label.text = Main.version_edition
	Main.emit_scene(Main.Scene.MainMenu)

func set_scene(scene: Variant, sc_name: String):
	vbox.get_child(0).queue_free()
	vbox.add_child(scene)
	vbox.move_child(scene, 0)
	scene.size_flags_vertical = SIZE_EXPAND_FILL
	scene.scene_name = sc_name

func prompt_game_save(confirm_overwrite = false):
	var confirm_action = (
		func():
			save_box.visible = true
			Main.save_callable()
			)
	if (confirm_overwrite):
		SignalBus.confirm_dialog.emit("Overwrite save?", confirm_action)
	else:
		confirm_action.call()
	
func save_game_end():
	await get_tree().create_timer(save_hide_delay).timeout
	save_box.visible = false