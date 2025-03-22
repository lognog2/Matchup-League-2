class_name DataEntity extends Object

var id: int
var id_str: String
var name: String
var season: int
var level: Level
var series: String

func _init(data = {}, initial = "DE"):
	SignalBus.done_loading.connect(connect_objs)
	if (data == {}): return
	data["initial"] = initial
	set_data(data)

func set_data(data: Dictionary, _on_init = false) -> DataEntity:
	if (data == {}): return self
	id = int(data.get("id", id))
	name = data.get("name", name)
	season = data.get("season", season)
	set_level(data.get("level name", Main.Levels.Prep.name)) #idc anymore
	set_series(data.get("series", series))
	set_id_str(data.get("initiial", ""))
	return self

func set_id_str(initial: String):
	if (initial.is_empty()): return
	id_str = initial + str(id)

func get_level_name() -> String: 
	return level.name

func set_level(level_name: String):
	level = Main.Levels[level_name]

func set_series(sr: String = Main.DEFAULT_SERIES):
	if (!sr):
		set_series()
	else:
		series = sr

## called after all entities done loading to set references to other entities
func connect_objs():
	pass

## compiles stats into rating
func get_rating() -> float:
	print("* blank data entity can't have a rating")
	return Main.GameRound.Debug

func get_rating_scale() -> int:
	print("* blank data entity can't have a rating scale")
	return Main.GameRound.Debug

func is_archive() -> bool:
	return level.is_archive()

func format_save() -> Dictionary:
	var data = {
		"id": id,
		"name": name,
	}
	if (level.is_archive()) :
		data.merge({"season" = season}, true)
	return data
