extends Object

##key is seed, value is team
var bracket = {}
var tourney_round = -1

const MAX_TEAMS = 256

var config = {
    seeding = Seeding.TRADITIONAL,
    reseed = false,     # reseed remaining teams after each round
    flat_factor = 0,    # at 0, number of byes is minimized
}

enum Seeding {
    TRADITIONAL,
    NONE, 
}
    

func load_config(data: Dictionary):
    config.merge(data, true)

func _init(teams: Array[Team], sort = Filter.Sort.Default):
    if (teams.size() <= 1):
        Err.print_fatal("Not enough teams to start tournament", Err.Fatal.Insufficient)
    teams.sort_custom(sort)
    for i in range (1, teams.size() + 1):
        bracket[i] = teams[i]

func set_round_games():
    var full = full_bracket_size()
    for i in range (bracket.size() + 1, full + 1):
        bracket[i] = null

## gets bracket size including byes.
## this is calculated by taking 2^n,
## where n is the log base 2 of the # of real teams, rounded up
func full_bracket_size() -> int:
    var n = (ceil(log(bracket.size()) / log(2.0)) + config.flat_factor)
    return 2 ** n