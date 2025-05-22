extends Menu

@export var backup_options: OptionButton
@export var theme_options: OptionButton

var setting: Dictionary

func _ready():
	scene_name = Main.Scene.SettingsMenu
	render()

func render():
	setting = Setting.s

	backup_options.clear()
	for item in Setting.SaveSpot:
		backup_options.add_item(item.replace("_", " "))
	backup_options.selected = setting.save_backup
	
	theme_options.clear()
	var i = 0
	for key in Setting.ThemeColor.keys():
		theme_options.add_item(key.replace("_", " "))
		if (NodeUtil.compare_colors(setting.theme, Setting.ThemeColor[key])):
			theme_options.selected = i
		i += 1

func _ledger_input(event: InputEvent):
	Err.print(event)

func _save():
	super._save()
	Stream.queue(func(): render())

func backup_change(idx: int):
	setting.save_backup = idx

func theme_change(idx: int):
	setting.theme = Setting.ThemeColor.values()[idx]
	NodeUtil.set_bg_theme()
