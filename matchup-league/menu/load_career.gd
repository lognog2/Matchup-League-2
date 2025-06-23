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
	var cards = []
	for dir in dirs:
		var new_card = blank_career.duplicate()
		var path = FileUtil.data_path + "/" + dir + "/" 
		var data = FileUtil.read_from_file(path + Career.FILE_NAME)
		data["dir_name"] = dir
		data["timestamp"] = get_timestamp(path)
		new_card.render(data)
		cards.append(new_card)

	cards.sort_custom(func(a, b): return a.timestamp < b.timestamp)
	for card in cards:
		blank_career.add_sibling(card)

func get_timestamp(dir_path: String) -> int:
	var abs_path = dir_path + Setting.FILE_NAME
	var config = Setting.load_config(abs_path)
	var datetime = config.get_value(Setting.Section.SYS, "timestamp")
	var timestamp = Time.get_unix_time_from_datetime_string(datetime)
	return timestamp
