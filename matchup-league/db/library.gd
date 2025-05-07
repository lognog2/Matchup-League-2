## holds dictionary and does save/load for each type of data entity on this level
class_name EntityLibrary extends Object

const file_path = "res://data/%s/%s.save"
var dict = {}
var last_id = 0
var avg_rating = 0.0
const AVG_RS = 75 ## average for rating scale
var level_name: String
var entity_name: String
var file_name: String

func _init(lvl_name: String, ent_name: String):
	level_name = lvl_name
	entity_name = ent_name
	file_name = "%s_%ss" % [level_name.to_lower(), entity_name.to_lower()]

# set/get

## constructs a new entity and adds it to dictionary
func add_entity(data: Dictionary, connect_obj = false) -> DataEntity:
	data["id"] = increment_id()
	var de = Main.blank_entity(entity_name).set_data(data)
	dict[de.id] = de
	if (connect_obj): de.connect_objs()
	add_avg_rating(de.get_rating())
	return de

## updates an entity's info
func set_entity(data: Dictionary) -> DataEntity:
	var de = get_entity(int(data["id"])).set_data(data)
	return de

## gets entity with `id`
func get_entity(id: int) -> DataEntity:
	var de = dict.get(id)
	#if (!de):
		#Err.print_warn("%s %d not found" % [entity_name, id], Err.Warn.NoAction)
	return de

func remove_entity(de: DataEntity):
	var id = de.id
	de.level = null
	dict.erase(id)
	if (last_id > id):
		last_id = id

## returns next available id
func increment_id() -> int:
	var de = dict.get(last_id)
	if (de):
		last_id = de.id + 1
		return increment_id()
	else:
		last_id += 1
		return last_id - 1
	
## gets a random entity from a pool that passes filter
func random_entity(filter = Filter.Select.Default) -> DataEntity:
	var pool = get_entities(filter)
	var id = randi() % pool.size()
	return pool[id]

func get_rating_scale(r: float) -> int:
	var rs = (r / avg_rating) * AVG_RS
	return rs
	
func set_avg_rating():
	var total = 0.0
	var vals = dict.values()
	for i in range (vals.size()):
		total += vals[i].get_rating()
	avg_rating = total / vals.size()

## assumes entity was already added to dict and connected to refs
func add_avg_rating(new_r: float):
	if (round(new_r) == 0): return
	var total = avg_rating * (dict.size() - 1)
	total += new_r
	avg_rating = total / dict.size()

## assumes entity was already removed from dict but not separated from refs yet
func remove_avg_rating(old_r: float):
	if (round(old_r) == 0): return
	var total = avg_rating * (dict.size() + 1)
	total -= old_r
	avg_rating = total / dict.size()

# queries

## returns first instance of name in dictionary
func find_entity(search_name: String) -> DataEntity:
	if (!Main.validate_name(search_name)): return null
	var matches = get_entities(func(de): return de.name() == search_name)
	if (matches.size() != 1):
		return null
	else:
		return matches[0]

## gets array of names of entites that pass filter, sorted alphabetically
func get_names(filter = Filter.Select.Default) -> Array:
	var validNames = []
	for val in dict.values():
		if (filter.call(val)):
			validNames.append(val.name())
	validNames.sort()
	return validNames

func get_entities(select_filter = Filter.Select.Default, sort_filter = null, limit = -1) -> Array:
	var valid_entities = []
	for val in dict.values():
		if (select_filter.call(val)):
			valid_entities.append(val)
	if (sort_filter): valid_entities.sort_custom(sort_filter)
	if (limit > -1): valid_entities = valid_entities.slice(0, limit)
	return valid_entities

# save/load (careful using breakpoints here)

func save_to_file(softSave: bool):
	var file = FileAccess.open(file_path % file_name, FileAccess.WRITE)
	var backup_file
	if (!softSave): backup_file = FileAccess.open(file_path % (file_name + "_backup"), FileAccess.WRITE)
	for id in dict:
		var data = dict[id].format_save()
		var json_data = JSON.stringify(data)
		file.store_line(json_data)
		if (!softSave): backup_file.store_line(json_data)

func load_from_file():
	reset()
	var file = FileAccess.open(file_path % file_name, FileAccess.READ)
	if (!file): return
	while file.get_position() < file.get_length():
		var line = file.get_line()
		var json = JSON.new()
		if json.parse(line) != OK:
			Err.print_fatal("JSON Parse Error: " + json.get_error_message() + " in " + line + " at line " + json.get_error_line(), Err.Fatal.ReadWrite)
			continue
		var data = json.data
		data["level name"] = level_name
		data["season"] = Main.get_season()
		add_entity(data)

func reset():
	for de in dict.values():
		de.free()
	dict.clear()
	last_id = 0
	avg_rating = 0.0
