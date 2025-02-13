extends Control

static var season: int

const MAX_TYPES = 5
const MIN_BASE = 500
const MAX_BASE = 10000
const MIN_MOD = 0
const MAX_MOD = 300

static var Types = {
	0: "M",
	1: "R",
	2: "E",
	3: "F",
	4: "W",
	5: "L",
	6: "A",
	7: "G",
	8: "C",
	9: "I",
	10: "S",
	11: "V"
}

static var Levels = {
	"Prep": Level.new("Prep", 4),
	"College": Level.new("College", 5),
	"Pro": Level.new("Pro", 11),
	"Archive": Level.new("Archive")
}

func _ready() -> void:
	season = 29
	loadState()
	SignalBus.openTable.emit()
	
	
static func getLevel(levelName):
	return Levels[levelName]
	
static func getSeason(): return season

static func saveState(softSave = true):
	for level in Levels:
		Levels[level].saveToFile(softSave)

static func loadState():
	Levels["Prep"].loadData()
	SignalBus.doneLoading.emit()
