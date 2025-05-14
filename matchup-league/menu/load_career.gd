extends Menu

@export var blank_career: CareerCard
@export var no_careers_label: Label

func _ready():
	blank_career.visible = false
	no_careers_label.visible = false
	add_careers()

func add_careers():
	var dirs = FileUtil.get_save_dirs()
	if (dirs.is_empty()):
		no_careers_label.visible = true
	for dir in dirs:
		var new_card = blank_career.duplicate()
		blank_career.add_sibling(new_card)
		var path = FileUtil.data_path + "/" + dir + "/" + Career.FILE_NAME
		var data = FileUtil.read_from_file(path)
		new_card.render(data)
