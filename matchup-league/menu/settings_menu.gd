extends Menu

@export var save_backup: OptionButton

var setting

func _ready():
	scene_name = Main.Scene.SettingsMenu
	render()

func render():
	setting = Setting.s

	for i in Setting.SaveSpot:
		save_backup.add_item(i)
	save_backup.selected = setting.save_backup

func _ledger_input(event: InputEvent):
	print(event)

func _save():
	
	super._save()
	Stream.queue(func(): render())
