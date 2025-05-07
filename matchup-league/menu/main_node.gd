extends Control

@export var vbox: VBoxContainer
@export var version_label: Label
@export var seed_label: Label
@export var save_box: Container

const save_hide_delay = 0.5 ## in seconds

func _ready():
	#SignalBus.done_saving.connect(save_game_end)
	Main.main_node = self
	save_box.visible = false;
	version_label.text = Main.version_edition
	seed_label.text += str(Main.game_seed)
	Main.emit_scene(Main.Scene.MainMenu)

func set_scene(scene: Variant, sc_name: String):
	vbox.get_child(0).queue_free()
	vbox.add_child(scene)
	vbox.move_child(scene, 0)
	scene.size_flags_vertical = SIZE_EXPAND_FILL
	scene.scene_name = sc_name

func save_game_start():
	save_box.visible = true

func save_game_end():
	await get_tree().create_timer(save_hide_delay).timeout
	save_box.visible = false
