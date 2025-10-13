extends Node

const data_path = "res://data"
const default_name = "default"
var default_path = "%s/%s" % [data_path, default_name]
const SAVE_ID = "save_"
const BACKUP_EXT = "_backup"
var save_path = default_path

func open_file(path = save_path, write = true) -> FileAccess:
	var flag = FileAccess.WRITE if (write) else FileAccess.READ
	var file = FileAccess.open(path, flag)
	if (!file): 
		Err.print_warn("File not found: %s" % path, Err.Warn.ReadWrite)
		file = FileAccess.open(path, FileAccess.WRITE)
		file.store_string(".")
		file = open_file(path, write)
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
		#Err.print("/ " + str(reps))

func get_save_dirs() -> Array:
	var dirs = DirAccess.get_directories_at(data_path)
	var save_dirs = Filter.filter_array(dirs, dirs_filter)
	return save_dirs

func dirs_filter(target: String) -> Callable:
	return func(dir: String = target):
		if (Main.edition == Main.Edition.Dev):
			return true
		return dir.contains(FileUtil.SAVE_ID)

func save_dir_name(alt = default_name) -> String:
	var dir: String
	var prefix = SAVE_ID if (!Setting.s.hidden && !alt.begins_with(SAVE_ID)) else ""
	if (alt != default_name):
		dir = prefix + alt
	elif (Main.current_career):
		dir = prefix + Main.current_career.name()
	else: 
		dir = alt
	return dir

## set save path to res://data/`file_name`
## if left blank, sets to default
func set_save_path(file_name = ""):
	if (file_name.is_empty()):
		file_name = default_name
	save_path = "%s/%s" % [data_path, save_dir_name(file_name)]
	Err.print("/ save path: %s" % save_path)

func save_dir_exists(create_if_not = false) -> bool:
	var dirs = get_save_dirs()
	var dir_name = save_dir_name()
	var has_dir = dirs.has(dir_name)
	if (!has_dir && create_if_not):
		set_save_path(dir_name)
		create_dir(save_path)
	return has_dir

func write_config(config: ConfigFile, path: String):
	var result = config.save(path)
	if (result != OK): 
		Err.print_fatal("Error saving config file: error code %d" % result, Err.Fatal.ReadWrite)

func create_dir(path: String):
	var error = DirAccess.make_dir_recursive_absolute(path)
	if (error != OK): 
		Err.print_fatal("Error creating dir: error code %d" % error, Err.Fatal.ReadWrite)

##absolute paths
func copy_file(from: String, to: String):
	var error = DirAccess.copy_absolute(from, to)
	if (error != OK):
		Err.print_fatal("Error copying file: error code %d" % error, Err.Fatal.ReadWrite)

func on_default() -> bool:
	return (default_path == save_path)
