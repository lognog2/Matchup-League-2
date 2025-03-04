class_name DataEntity extends Object

var id: int
var id_str: String
var name: String
var season: int
var level: Level

func _init(data: Dictionary, initial = "DE"):
	SignalBus.done_loading.connect(connect_objs)
	set_data(data)
	set_id_str(initial)

func set_data(data: Dictionary) -> DataEntity:
	id = int(data.get("id", id))
	name = data.get("name", name)
	season = data.get("season", season)
	set_level("Prep") #idc anymore
	return self

func set_id_str(initial: String):
	id_str = initial + str(id)

func get_level_name(): return level.name

func set_level(level_name: String):
	level = Main.Levels[level_name]

## called after all entities done loading to set references to other entities
func connect_objs():
	pass

func format_save() -> Dictionary:
	return {
		"id": id,
		"name": name,
	}
