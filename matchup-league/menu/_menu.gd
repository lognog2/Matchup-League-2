class_name Menu extends Control

var level: Level
var scene_name: String

func _enter_tree():
	set_level()

func set_level(lvl: Level = Main.Levels.Prep):
	level = lvl
