class_name Level extends Object

#init vars
var name: String
var FPT: int

var Lib = {
	Fighter = null,
	Team = null,
	Game = null,
}

func _init(levelName: String, fpt = 100):
	name = levelName
	FPT = fpt
	Lib.Fighter = EntityLibrary.new(name, Main.Entity.Fighter)
	Lib.Team = EntityLibrary.new(name, Main.Entity.Team)
	Lib.Game = EntityLibrary.new(name, Main.Entity.Game)

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

func get_fighters(filter = Filter.Select.Default) -> Array: 
	return Lib.Fighter.get_entities(filter)

func get_teams(filter = Filter.Select.Default) -> Array: 
	return Lib.Team.get_entities(filter)

func get_games(filter = Filter.Select.Default) -> Array: 
	return Lib.Game.get_entities(filter)

func get_teams_sorted(filter = Filter.Sort.Alphabet) -> Array:
	return Lib.Team.get_entities(Filter.Select.Default, filter)

func get_f_names(filter = Filter.Select.Default) -> Array: 
	return Lib.Fighter.get_names(filter)

func get_t_names(filter = Filter.Select.Default) -> Array: 
	return Lib.Team.get_names(filter)

## gets a team's rating scale
func get_team_rs(t: Team):
	return Lib.Team.get_rating_scale(t.get_rating())

## finds the first fighter with `n` name
func find_fighter(n: String) -> Fighter: 
	return Lib.Fighter.find_entity(n)

## finds the first team with `n` name
func find_team(n: String) -> Team: 
	return Lib.Team.find_entity(n)

## gets random team
func random_team(filter = Filter.Select.Default) -> Team: 
	return Lib.Team.random_entity(filter)

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
class EntityLibrary:
	const file_path = "res://data/%s.save"
	var dict = {}
	var last_id = 0
	var avg_rating = 0.0 #average rating
	const AVG_RS = 1000
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
		for i in range(vals.size()):
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
		var matches = get_entities(func(de): return de.name == search_name)
		if (matches.size() != 1):
			return null
		else:
			return matches[0]
	
	## gets array of names of entites that pass filter, sorted alphabetically
	func get_names(filter = Filter.Select.Default) -> Array:
		var validNames = []
		for val in dict.values():
			if (filter.call(val)):
				validNames.append(val.name)
		validNames.sort()
		return validNames

	func get_entities(select_filter = Filter.Select.Default, sort_filter = null) -> Array:
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
