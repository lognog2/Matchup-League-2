extends Node

const data_path = "res://data"
const default_name = "default"
var save_path = "%s/%s" % [data_path, default_name]

func open_file(path = save_path, write = true) -> FileAccess:
	var flag = FileAccess.WRITE if (write) else FileAccess.READ
	return FileAccess.open(path, flag)

func write_to_file(content: Variant, path: String = save_path):
	var data = JSON.stringify(content)
	var file = open_file(path, true)
	file.store_string(data)

func do_each_line(action: Callable, path: String = save_path, limit = -1):
	var file = open_file(path, false)
	if (!file): Err.alert_fatal("Failed to open %s" + path, Err.Fatal.ReadWrite)
	var reps = 0
	while (file.get_position() < file.get_length() && reps > limit):
		var line = file.get_line()
		action.call(line)
		reps += 1

func get_save_dirs():
	return DirAccess.get_directories_at(data_path)

func save_dir_name() -> String:
	var dir = "save_" + Main.current_career.name() if (Main.current_career) else default_name
	return dir

func set_save_path():
	save_path = "%s/%s" % [data_path, save_dir_name()]

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
