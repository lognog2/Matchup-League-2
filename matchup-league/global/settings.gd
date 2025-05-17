class_name Settings extends Node

var config

var s = {

}

func _ready():
    config = ConfigFile.new()

func add_setting(key: String, val: Variant = 0, replace = false):
    if (!replace && s.keys().has(key)):
        Err.alert_warn("setting %s already exists" % key, Err.Warn.Conflict)
    else:
        s[key] = val

func save():
    
    config.save()

func load():
    pass


