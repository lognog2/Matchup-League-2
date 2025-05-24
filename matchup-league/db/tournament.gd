extends Object

##key is seed, value is team
var bracket = {}
var tourney_round = -1

const MAX_TEAMS = 256
    

func _init(teams: Array[Team], sort = Filter.Sort.Rating):
    if (teams.size() <= 1):
        Err.print_fatal("Not enough teams to start tournament", Err.Fatal.Insufficient)
    teams.sort_custom(sort)
    for i in range (1, teams.size() + 1):
        bracket[i] = teams[i]

func set_round_games():
    var full = full_bracket_size()
    # full = 16, bracket = 14
    for i in range (bracket.size() + 1, full + 1):
        bracket[i] = null

## gets bracket size including byes.
## this is calculated by taking 2^n,
## where n is the log base 2 of the # of real teams, rounded up
func full_bracket_size() -> int:
    var n = ceil(log(bracket.size()) / log(2.0))
    return 2 ** n