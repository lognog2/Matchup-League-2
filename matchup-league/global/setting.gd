class_name Settings extends Node

var config



enum SaveSpot {
    Never,
    Main_menu,
    Click,
    New_career,
}

var s = {
    save_backup = SaveSpot.Main_menu,

}

func _ready():
    config = ConfigFile.new()

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

func save():
    var path = FileUtil.save_path + "/settings.cfg"
    config.save(path)

func load():
    pass


