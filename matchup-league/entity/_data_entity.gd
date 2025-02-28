class_name DataEntity extends Object

var id: int
var name: String
var season: int
var level: Level

func _init(data: Dictionary):
	SignalBus.done_loading.connect(connect_objs)
	set_data(data)

func set_data(data: Dictionary):
	id = int(data.get("id", id))
	name = data.get("name", name)
	season = data.get("season", season)
	set_level("Prep") #idc anymore

func get_level_name(): return level.name

func set_level(level_name: String):
	level = Main.Levels[level_name]

## called after all entities done loading to make refs to other entities
func connect_objs():
	pass

func format_save() -> Dictionary:
	return {
		"id": id,
		"name": name,
	}
