extends Node

const FILE_FORMAT = "settings%s.cfg"
const FILE_NAME = FILE_FORMAT % ""
const FILE_BACKUP = FILE_FORMAT % FileUtil.BACKUP_EXT

enum SaveSpot {
	Never, # never
	Main_menu, # just before returning to main menu
	Click_save, # when a 'save' button is clicked
}

var Section = {
	SET = "settings",
	SYS = "system",
	RNG = "rng",
}

var ThemeColor = {
	Red = Color.DARK_RED,
	Orange = Color.DARK_ORANGE,
	Green = Color.FOREST_GREEN,
	Blue = Color.MEDIUM_BLUE,
	Purple = Color8(59, 2, 95),
	Black = Color.BLACK,
	Pink = Color8(153, 15, 114),
	Brown = Color8(43, 27, 15),
	Gold = Color8(184, 146, 9),
	Teal = Color.TEAL,
	Maroon = Color8(66, 5, 5),
	Silver = Color.DIM_GRAY,
}

var DEFAULT_COLOR = ThemeColor.Purple

var s_default = {
	hidden = false, ## hidden when not on developer edition
	rating_scale = Rating.Scale.MEDIUM,
	save_backup = SaveSpot.Main_menu,
	theme = DEFAULT_COLOR,
}

var s = s_default.duplicate()

func _ready() -> void:
	SignalBus.new_career.connect(reset_settings)

func add_setting(key: String, val: Variant = 0, replace = false):
	if (!replace && s.get(key)):
		Err.alert_warn("setting %s already exists" % key, Err.Warn.Conflict)
	else:
		s[key] = val

func get_setting(setting_name: String) -> Variant:
	return s.get(setting_name)

func set_setting(setting_name: String, setting_val: Variant):
	if (!s.get(setting_name)):
		Err.print_warn("setting %s does not exist, adding it instead" % setting_name, Err.Warn.Runtime)
		add_setting(setting_name)
		return
	s[setting_name] = setting_val

func config_file_path(backup = false) -> String:
	var file_name = FILE_BACKUP if (backup) else FILE_NAME
	var path = FileUtil.save_path + "/" + file_name
	return path

func reset_settings():
	s = s_default.duplicate()

func load_config(path = "") -> ConfigFile:
	if (path.is_empty()):
		path = config_file_path()

	var config = ConfigFile.new()
	var result = config.load(path)
	if (result != OK): 
		if (result == ERR_FILE_NOT_FOUND):
			Err.print_warn("Config file not found, saving to new one", Err.Warn.ReadWrite)
			self.save(false)
			self.load()
		else:
			Err.print_fatal("Error loading config file: ", Err.Fatal.ReadWrite)
	return config

func get_seed():
	return Main.rep.get_seed()

func get_state():
	Main.rep.get_state()

func save(backup = false):
	var config = ConfigFile.new()

	for key in s.keys():
		config.set_value(Section.SET, key, s[key])

	var sys_info = Main.system_info()
	for key in sys_info.keys():
		config.set_value(Section.SYS, key, sys_info[key])

	var rng = Section.RNG
	if (!FileUtil.on_default()): config.set_value(rng, "seed", get_seed())
	config.set_value(rng, "state", get_state())
	
	var paths = [config_file_path(false)]
	if (backup):
		paths.append(config_file_path(true))

	for path in paths:
		FileUtil.write_config(config, path)
		
func load():
	var config = load_config()
	var config_version = config.get_value(Section.SYS, "version")
	if (config_version != Main.str_version()):
		Err.print_warn("File is from an old version: %s" % config_version, Err.Warn.Outdated)

	reset_settings()
	for key in config.get_section_keys(Section.SET):
		add_setting(key, config.get_value(Section.SET, key), true)

	var rseed = config.get_value(Section.RNG, "seed", get_seed())
	var state = config.get_value(Section.RNG, "state", get_state())
	Main.set_seed(rseed, state)
	
func get_timestamp(dir_path: String) -> int:
	var abs_path = dir_path + FILE_NAME
	var config = load_config(abs_path)
	var datetime = config.get_value(Section.SYS, "timestamp")
	var timestamp = Time.get_unix_time_from_datetime_string(datetime)
	return timestamp
