extends Node

const data_path = "res://data"
const default_name = "default"
const SAVE_ID = "save_"
var save_path = "%s/%s" % [data_path, default_name]

func open_file(path = save_path, write = true) -> FileAccess:
	var flag = FileAccess.WRITE if (write) else FileAccess.READ
	var file = FileAccess.open(path, flag)
	if (!file): Err.print_fatal("File not found: %s" % path, Err.Fatal.ReadWrite)
	return file

func write_to_file(content: Variant, path: String = save_path):
	var data = JSON.stringify(content)
	var file = open_file(path, true)
	file.store_string(data)

func read_from_file(path: String = save_path) -> Variant:
	var file = open_file(path, false)
	var content = file.get_as_text()
	var json = JSON.new()
	if json.parse(content) != OK:
		Err.print_fatal("JSON Parse Error: " + json.get_error_message() + " in " + content, Err.Fatal.ReadWrite)
		return
	var data = json.data
	return data

func do_each_line(action: Callable, path: String = save_path, limit = -1):
	var file = open_file(path, false)
	if (!file): Err.alert_fatal("Failed to open %s" + path, Err.Fatal.ReadWrite)
	var reps = 0
	while (file.get_position() < file.get_length() && reps > limit):
		var line = file.get_line()
		action.call(line)
		reps += 1

func get_save_dirs() -> Array:
	var dirs = DirAccess.get_directories_at(data_path)
	var save_dirs = Filter.filter_array(dirs, func(dir): return dir.contains(FileUtil.SAVE_ID))
	return save_dirs

func save_dir_name(alt = default_name) -> String:
	var dir: String
	if (alt != default_name):
		dir = SAVE_ID + alt
	elif (Main.current_career):
		dir = SAVE_ID + Main.current_career.name()
	else: 
		dir = alt
	return dir

func set_save_path(file_name = ""):
	if (file_name.is_empty()):
		file_name = default_name
	save_path = "%s/%s" % [data_path, save_dir_name(file_name)]

func copy_file(in_string: String, out_string: String):
	var in_file = open_file(in_string, false)
	var out_file = open_file(out_string, true)
	out_file.store_string(in_file.get_as_text())

func save_dir_exists(create_if_not = false) -> bool:
	var dirs = get_save_dirs()
	var has_dir = dirs.has(save_dir_name())
	if (!has_dir && create_if_not):
		DirAccess.make_dir_absolute(save_path)
	return has_dir
