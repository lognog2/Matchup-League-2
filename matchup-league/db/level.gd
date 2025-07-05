class_name Level extends Object

#init vars
var name: String

var playoff: Tournament

var config = {
	rank_amt = 15,
	playoff_amt = 12,
	playoff_name = "playoff",
	FPT = 0,
	FPG = 0,
}

var Lib = {
	Fighter = null,
	Team = null,
	Game = null,
	Player = null,
	Tourney = null,
}

static func get_id(de: Variant = null):
	return de.id if (de) else -1

func _init(levelName: String, fpg = 100, fpt = 100):
	name = levelName
	config.playoff_name = "%d %s Finals" % [Main.season, name]
	config.FPT = fpt
	config.FPG = fpg
	Lib.Fighter = EntityLibrary.new(name, Main.Entity.Fighter)
	Lib.Team = EntityLibrary.new(name, Main.Entity.Team)
	Lib.Game = EntityLibrary.new(name, Main.Entity.Game)
	Lib.Player = EntityLibrary.new(name, Main.Entity.Player)
	Lib.Tourney = EntityLibrary.new(name, Main.Entity.Tournament)

func get_fpg() -> int:
	return config.FPG

func get_FPG(): return get_fpg()

func get_fpt() -> int:
	return config.FPT

func get_FPT(): return get_fpt()

# get entity by id

func get_fighter(id: int = 0) -> Fighter: 
	return Lib.Fighter.get_entity(id)

func get_team(id: int = 0) -> Team: 
	return Lib.Team.get_entity(id)

func get_game(id: int = 0) -> Game: 
	return Lib.Game.get_entity(id)

func get_player(id: int = 0) -> Player: 
	return Lib.Player.get_entity(id)

func get_tournament(id: int = 0) -> Tournament: 
	return Lib.Tourney.get_entity(id)

func is_archive() -> bool:
	return false

func find_game(r: Variant, oppID: int) -> Game:
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

func get_teams_filtered(select = Filter.Select.Default, sort = Filter.Sort.Rating, limit = -1) -> Array:
	return Lib.Team.get_entities(select, sort, limit)

func get_teams_limited(select = Filter.Select.Default, limit = -1) -> Array:
	return Lib.Team.get_entities(select, Filter.Sort.Rating, limit)

func get_games(filter = Filter.Select.Default) -> Array: 
	return Lib.Game.get_entities(filter)

func get_games_sorted(filter = Filter.Sort.Rating, limit = -1) -> Array:
	return Lib.Team.get_entities(Filter.Select.Default, filter, limit)

func get_games_filtered(select = Filter.Select.Default, sort = Filter.Sort.Rating) -> Array:
	return Lib.Game.get_entities(select, sort)

## gets all games in specified round `r`
func get_current_games(r: Variant) -> Array:
	return get_games_filtered(Filter.select_by_round(r))

func get_players(filter = Filter.Select.Default) -> Array: 
	return Lib.Player.get_entities(filter)


# get list of names

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

func find_tournament(n: String) -> Tournament:
	return Lib.Tourney.find_entity(n)

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

func add_existing_game(g: Game) -> Player:
	return Lib.Game.add_existing_entity(g, false, true)

func set_game(data: Dictionary) -> Game:
	return Lib.Game.set_entity(data)


func add_player(data: Dictionary) -> Player:
	return Lib.Player.add_entity(data)

func add_existing_player(p: Player) -> Player:
	return Lib.Player.add_existing_entity(p, false, true)

func set_player(data: Dictionary) -> Player:
	return Lib.Player.set_entity(data)

func add_tournament(data: Dictionary, connect_obj = false) -> Tournament:
	return Lib.Tourney.add_entity(data, connect_obj)

func add_existing_tournament(tn: Tournament) -> Tournament:
	return Lib.Tourney.add_existing_entity(tn, false, true)

func begin_playoff():
	set_rankings()
	if (find_tournament((config.playoff_name))): return
	var teams = get_teams_filtered(Filter.Select.TeamQualified, Filter.Sort.TeamRank)
	var ids = []
	for t in teams:
		ids.append(t.id)
	var tn_data = {
		"name" = config.playoff_name,
		"season" = Main.season,
		"team ids" = ids,
		"level name" = name,
	}
	var tn = add_tournament(tn_data, true)
	playoff = tn
	if (self == Main.current_career.get_level()):
		Main.current_career.current_round = playoff.tourney_key()

## runs any unfinished games as cpu vs cpu
func sim_round(r: Variant):
	for g in get_current_games(r):
		g.sim_game()

## returns array of top `rank_amt` teams
func set_rankings() -> Array:
	var teams_ranked = get_teams_sorted(Filter.Sort.Rating)
	var top_teams = []
	var i = 1
	for t in teams_ranked:
		#print ("/ %s: %.f" % [t.name(), t.get_rating()])
		if (i > config.rank_amt):
			t.rank = 0
		else:
			t.rank = i
			top_teams.append(t)
			i += 1
	return top_teams

## call `Main.save_state()` instead 
func save_data(backup: bool):
	#Err.print("/ %s: last chance to look at the save data" % name) #breakpoint safe space
	for lib in Lib.values():
		lib.save_to_file(backup)

## call `Main.load_state()` instead
func load_data():
	for lib in Lib.values():
		lib.load_from_file()


# redirect funcs

## redirects to `get_tournament`
func get_tourney(id): return get_tournament(id)
