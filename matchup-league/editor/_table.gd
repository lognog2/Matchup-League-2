class_name Table extends Menu

@export var tab_container: TabContainer
@export var fighter_table: Table
@export var team_table: Table


func _enter_tree():
	#print("/ table")
	scene_name = Main.Scene.Editor
	set_level()

#returns index of current tab
func getCurrentTab(): return tab_container.current_tab
