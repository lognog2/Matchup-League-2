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