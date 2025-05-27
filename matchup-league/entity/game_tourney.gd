class_name TourneyGame extends Game

var tourn_id
var tourney: Tournament
var tourney_id = -1

static func create(t1: Team, t2: Team, t: Tournament, r: int) -> TourneyGame:
	var data = {
		"team1id" = t1.id,
		"team2id" = t2.id,
		"tournament id" = t.id,
		"round" = r,
		"level name" = t1.level.name,
	}
	var tg = TourneyGame.new(data)
	tg.level.add_existing_game(tg)
	return tg

func set_data(data: Dictionary, init = false) -> TourneyGame:
	super(data)
	if (data == {}): return super(data, init)
	tourney_id = data.get("tournament id", tourney_id)
	rnd = data.get("round")[2] if data.get("round") else rnd
	return self

func connect_objs():
	tourney = level.get_tourney(tourney_id)
	super()

func format_save() -> Dictionary:
	var data = super()
	data.merge({
		"type" = "tourney game",
		"name" = tourney.name(),
		"tournament" = tourney_id,
	}, true)
	return data
