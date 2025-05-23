class_name Level extends Object

#init vars
var name: String
var FPT: int
var FPG: int
var RANK_AMT = 15

var Lib = {
	Fighter = null,
	Team = null,
	Game = null,
	Player = null,
}

func _init(levelName: String, fpg = 100, fpt = 100):
	name = levelName
	FPT = fpt
	FPG = fpg
	Lib.Fighter = EntityLibrary.new(name, Main.Entity.Fighter)
	Lib.Team = EntityLibrary.new(name, Main.Entity.Team) # :3
	Lib.Game = EntityLibrary.new(name, Main.Entity.Game)
	Lib.Player = EntityLibrary.new(name, Main.Entity.Player)

func get_fighter(id: int = 0) -> Fighter: 
	return Lib.Fighter.get_entity(id)

func get_team(id: int = 0) -> Team: 
	return Lib.Team.get_entity(id)

func get_game(id: int = 0) -> Game: 
	return Lib.Game.get_entity(id)

func get_player(id: int = 0) -> Player: 
	return Lib.Player.get_entity(id)

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

func get_fighters_sorted(filter = Filter.Sort.Alphabet, limit = -1) -> Array:
	return Lib.Fighter.get_entities(Filter.Select.Default, filter, limit)

func get_teams(filter = Filter.Select.Default) -> Array: 
	return Lib.Team.get_entities(filter)

func get_teams_sorted(filter = Filter.Sort.Alphabet, limit = -1) -> Array:
	return Lib.Team.get_entities(Filter.Select.Default, filter, limit)

func get_teams_filtered(select = Filter.Select.Default, sort = Filter.Sort.Rating) -> Array:
	return Lib.Team.get_entities(select, sort)

func get_games(filter = Filter.Select.Default) -> Array: 
	return Lib.Game.get_entities(filter)

func get_games_sorted(filter = Filter.Sort.Rating, limit = -1) -> Array:
	return Lib.Team.get_entities(Filter.Select.Default, filter, limit)

func get_games_filtered(select = Filter.Select.Default, sort = Filter.Sort.Rating) -> Array:
	return Lib.Game.get_entities(select, sort)

## gets all games in specified round `r`
func get_current_games(r: int) -> Array:
	return get_games_filtered(Filter.select_by_round(r))

func get_players(filter = Filter.Select.Default) -> Array: 
	return Lib.Player.get_entities(filter)

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

func random_team_exclude(exclude: Team) -> Team:
	return Lib.Team.random_entity(Filter.exclude_self(exclude))

func set_avg_rating():
	for lib in Lib.values():
		lib.set_avg_rating()

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

func add_game(data: Dictionary, conn = false) -> Game:
	return Lib.Game.add_entity(data, conn)

func set_game(data: Dictionary) -> Game:
	return Lib.Game.set_entity(data)

func add_player(data: Dictionary) -> Player:
	return Lib.Player.add_entity(data)

func set_player(data: Dictionary) -> Player:
	return Lib.Player.set_entity(data)

## runs any unfinished games as cpu vs cpu
func sim_round(r: int):
	for g in get_current_games(r):
		g.sim_game()

## returns array of top `RANK_AMT` teams
func set_rankings() -> Array:
	var teams_ranked = get_teams_sorted(Filter.Sort.Rating)
	var top_teams = []
	var i = 1
	for t in teams_ranked:
		#print ("/ %s: %.f" % [t.name(), t.get_rating()])
		if (i > RANK_AMT):
			t.rank = 0
		else:
			t.rank = i
			top_teams.append(t)
			i += 1
	return top_teams

## call `Main.save_state()` instead of individual level func
func save_data(backup: bool):
	Err.print("/ %s: last chance to look at the save data" % name) #breakpoint safe space
	for lib in Lib.values():
		lib.save_to_file(backup)

## call `Main.load_state()` instead of individual level func
func load_data():
	for lib in Lib.values():
		lib.load_from_file()
