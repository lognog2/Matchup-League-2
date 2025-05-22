extends Control

@export var root_container: Container
@export var vbox: VBoxContainer
@export var version_label: Label
@export var seed_label: Label
@export var save_box: Container
@export var confirm_box: Container
@export var confirm_label: Label

const save_hide_delay = 0.5 ## in seconds

var last_selection = true

var confirm_action: Callable

signal user_input(confirm: bool)

func _ready():
	#SignalBus.done_saving.connect(save_game_end)
	reset_user_select()
	Main.main_node = self
	save_box.visible = false
	confirm_box.visible = false
	version_label.text = Main.version_edition
	user_input.connect(set_user_input)
	Main.emit_scene(Main.Scene.MainMenu)

func set_scene(scene: Variant, sc_name: String):
	vbox.get_child(0).queue_free()
	vbox.add_child(scene)
	vbox.move_child(scene, 0)
	scene.size_flags_vertical = SIZE_EXPAND_FILL
	scene.scene_name = sc_name

func prompt_game_save(confirm_overwrite = false):
	confirm_action = (
		func():
			save_box.visible = true
			Main.save_callable()
			)
	if (confirm_overwrite):
		confirm_box.visible = true
		confirm_label.text = "Overwrite save?"
		Main.pause_game(true)
	else:
		confirm_action.call()
	
func save_game_end():
	await get_tree().create_timer(save_hide_delay).timeout
	save_box.visible = false

func set_user_input(confirm: bool):
	confirm_box.visible = false
	last_selection = confirm
	Main.pause_game(false)
	if (last_selection && confirm_action): confirm_action.call()
	reset_user_select()

func user_confirm() -> bool:
	return last_selection

func reset_user_select():
	last_selection = true
	confirm_action = func(): Err.print("/ empty confirm action")

func _confirm_input():
	Err.print("/ confirm")
	user_input.emit(true)

func _deny_input():
	Err.print("/ deny")
	user_input.emit(false)
	
