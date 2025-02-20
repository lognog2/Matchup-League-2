class_name DataEntity extends Object

var main = preload("res://main/main.gd")

var id: int
var name: String #optional
var season: int
var level: Level

func _init(data: Dictionary):
	id = int(data["id"])
	if (data.has("name")):
		name = data["name"]
	season = data["season"]
	setLevel(data["level"])
	
func getLevelName(): return level.name

func setLevel(levelName):
	level = main.Levels[levelName]
