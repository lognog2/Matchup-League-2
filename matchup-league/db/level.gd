class_name Level extends Object

#init vars
var name: String
var FPT: int

## selection filters
var Select = {
	Default = (func(_de): return true)
}

## sorting filters
var Sort = {
	Id = (func(a: DataEntity, b: DataEntity): 
		return a.id < b.id),
	Alphabet = (func(a: DataEntity, b: DataEntity): 
		return a.name.naturalcasecmp_to(b.name) < 0),
	Default = (func(_a: DataEntity, _b: DataEntity): 
		return false;)
}

var Lib = {
	Fighter = null,
	Team = null,
	Game = null,
}

func _init(levelName: String, fpt = 100):
	name = levelName
	FPT = fpt
	Lib.Fighter = EntityLib.new(name, Main.Entity.Fighter)
	Lib.Team = EntityLib.new(name, Main.Entity.Team)
	Lib.Game = EntityLib.new(name, Main.Entity.Game)

func get_fighter(id: int) -> Fighter: 
	return Lib.Fighter.get_entity(id)

func get_team(id: int) -> Team: 
	return Lib.Team.get_entity(id)

func get_game(id: int) -> Game: 
	return Lib.Game.get_entity(id)

func is_archive() -> bool:
	return false

func find_game(r: int, oppID: int) -> Game:
	var result = get_games(
		func (g: Game):
			if (g.rnd == r && g.has_team_id(oppID)):
				return true
			else: return false
	)
	if (result.size() != 1):
		return null
	else:
		return result[0]

# get list by filter

func get_fighters(filter = Select.Default) -> Array: 
	return Lib.Fighter.get_entities(filter)

func get_teams(filter = Select.Default) -> Array: 
	return Lib.Team.get_entities(filter)

func get_games(filter = Select.Default) -> Array: 
	return Lib.Game.get_entities(filter)

func get_teams_sorted(filter = Sort.Alphabet) -> Array:
	return Lib.Team.get_entities(Select.Default, filter)

func get_f_names(filter = Select.Default) -> Array: 
	return Lib.Fighter.get_names(filter)

func get_t_names(filter = Select.Default) -> Array: 
	return Lib.Team.get_names(filter)

## finds the first fighter with `n` name
func find_fighter(n: String) -> Fighter: 
	return Lib.Fighter.find_entity(n)

## finds the first team with `n` name
func find_team(n: String) -> Team: 
	return Lib.Team.find_entity(n)

func random_team() -> Team: 
	return Lib.Team.random_entity()

# save/load from file
# **be careful using breakpoints here**

func add_fighter(data: Dictionary) -> Fighter:
	return Lib.Fighter.add_entity(data)

func set_fighter(data: Dictionary) -> Fighter:
	return Lib.Fighter.set_entity(data)
	
func add_team(data: Dictionary) -> Team:
	return Lib.Team.add_entity(data)

func set_team(data: Dictionary) -> Team:
	return Lib.Team.set_entity(data)

func add_game(data: Dictionary) -> Game:
	return Lib.Game.add_entity(data)

func set_game(data: Dictionary) -> Game:
	return Lib.Game.set_entity(data)

func save_data(softSave: bool):
	print("/ last chance to look at the save data") #breakpoint safe space
	for lib in Lib.values():
		lib.save_to_file(softSave)

func load_data():
	for lib in Lib.values():
		lib.load_from_file()
	
## holds dictionary and does save/load for each type of data entity on this level
class EntityLib:
	const file_path = "res://data/%s.save"
	var default_filter = func(_de): return true
	var dict = {}
	var last_id = 0
	var level_name: String
	var entity_name: String
	var file_name: String

	func _init(lvl_name: String, ent_name: String):
		level_name = lvl_name
		entity_name = ent_name
		file_name = "%s_%ss" % [level_name.to_lower(), entity_name.to_lower()]

	# set/get

	## constructs a new entity and adds it to dictionary
	func add_entity(data: Dictionary) -> DataEntity:
		data["id"] = increment_id()
		var de = Main.blank_entity(entity_name).set_data(data)
		dict[de.id] = de
		return de

	## updates an entity's info (new info stored in data)
	func set_entity(data: Dictionary) -> DataEntity:
		var de = get_entity(int(data["id"])).set_data(data)
		return de
	
	func get_entity(id: int) -> DataEntity:
		var de = dict.get(id)
		#if (!de):
			#Err.print_warn("%s %d not found" % [entity_name, id], Err.Warn.NoAction)
		return de
	
	func increment_id() -> int:
		var de = dict.get(last_id)
		if (de):
			last_id = de.id + 1
			return increment_id()
		else:
			last_id += 1
			return last_id - 1
		
	func random_entity() -> DataEntity:
		var id = randi() % dict.size()
		return dict[id]

	# queries

	## returns first instance of name in dictionary
	func find_entity(search_name: String) -> DataEntity:
		if (!Main.validate_name(search_name)): return null
		var matches = get_entities(dict, func(de): return de.name == search_name)
		if (matches.size() != 1):
			return null
		else:
			return matches[0]
	
	## gets array of names of entites that pass filter, sorted alphabetically
	func get_names(filter = default_filter) -> Array:
		var validNames = []
		for val in dict.values():
			if (filter.call(val)):
				validNames.append(val.name)
		validNames.sort()
		return validNames

	func get_entities(select_filter = default_filter, sort_filter = null) -> Array:
		var validEntities = []
		for val in dict.values():
			if (select_filter.call(val)):
				validEntities.append(val)
		if (sort_filter): validEntities.sort_custom(sort_filter)
		return validEntities

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
