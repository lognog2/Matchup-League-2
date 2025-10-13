class_name ConfirmDialog extends Container

@export var dialog_label: Label

var on_confirm: Callable

var default_action = func(): Err.print_warn("No confirm action set", Err.Warn.NoAction)

func _ready():
	SignalBus.confirm_dialog.connect(prompt)
	reset()
	

func prompt(text: String, confirm_action: Callable):
	dialog_label.text = text
	self.on_confirm = confirm_action
	self.show()
	Main.pause_game(true)

func user_input(confirm: bool):
	Main.pause_game(false)
	if (confirm && on_confirm):
		on_confirm.call()
	reset()
	
func reset():
	self.hide()
	on_confirm = default_action

func _accept():
	user_input(true)

func _decline():
	user_input(false)
