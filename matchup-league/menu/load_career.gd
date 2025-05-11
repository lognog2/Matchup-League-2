extends Control

@export var blank_career: Container

func _ready():
	blank_career.visible = false

func add_careers():
	var dirs = FileUtil.get_save_dirs()
	for dir in dirs:
		var new_card = blank_career.duplicate()
		blank_career.add_sibling(new_card)
		new_card.render(dir + Career.FILE_NAME)
	
