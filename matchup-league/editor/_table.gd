class_name Table extends Menu

@export var tabContainer: TabContainer
@export var fighterTable: Table
@export var teamTable: Table


func _enter_tree():
	#print("/ table")
	scene_name = Main.Scene.Editor
	set_level()

#returns index of current tab
func getCurrentTab(): return tabContainer.current_tab
