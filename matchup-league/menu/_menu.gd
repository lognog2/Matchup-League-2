class_name Menu extends Control

var level: Level
var scene_name: String

func _enter_tree():
	set_level("Prep")

func set_level(lvl_name):
	#print("/ set level")
	if (!level): 
		#print("/ true")
		level = Main.get_level(lvl_name)
