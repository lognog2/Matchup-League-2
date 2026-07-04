class_name Menu extends Control

var level: Level
var scene_name: String

func _ready():
	set_level()

func set_level(lvl: Level = Main.Levels.Pro):
	level = lvl
	
func _back():
	Main.emit_scene()

## call when user manually clicks a save button
func _save():
	var backup = check_save_backup(Setting.SaveSpot.Click_save)
	Main.save_state(backup)

## returns true if current spot matches setting for saving to backup
func check_save_backup(spot: int) -> bool:
	return spot == Setting.get_setting("save_backup")
