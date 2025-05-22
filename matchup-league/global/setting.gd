class_name Settings extends Node

const SECTION = "settings"
var config = ConfigFile.new()

enum SaveSpot {
	Never,
	Main_menu,
	Click,
}

var ThemeColor = {
	Red = Color.DARK_RED,
	Orange = Color.DARK_ORANGE,
	Green = Color.FOREST_GREEN,
	Blue = Color.MEDIUM_BLUE,
	Purple = Color8(59, 2, 95),
	Black = Color.BLACK,
	Pink = Color.MAGENTA,
	Brown = Color.SADDLE_BROWN,
	Gold = Color8(184, 146, 9),
	Teal = Color.TEAL,
	Maroon = Color8(66, 5, 5),
	Silver = Color.DIM_GRAY,
}

var DEFAULT_COLOR = ThemeColor.Purple

var s = {
	save_backup = SaveSpot.Main_menu,
	theme = DEFAULT_COLOR,
}


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

func config_file_path() -> String:
	var path = FileUtil.save_path + "/settings.cfg"
	return path

func save():
	for key in s.keys():
		config.set_value(SECTION, key, s[key])
	var result = config.save(config_file_path())
	if (result != OK): Err.print_fatal("Error saving config file", Err.Fatal.ReadWrite)

func load():
	var result = config.load(config_file_path())
	if (result != OK): 
		if (result == ERR_FILE_NOT_FOUND):
			Err.print_warn("Config file not found, saving to new one", Err.Warn.ReadWrite)
			self.save()
			self.load()
		else:
			Err.print_fatal("Error loading config file: ", Err.Fatal.ReadWrite)
	s.clear()
	for key in config.get_section_keys(SECTION):
		add_setting(key, config.get_value(SECTION, key))
