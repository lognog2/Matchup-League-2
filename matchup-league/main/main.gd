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

## names reserved for program functions
static var Keyname = {
	"remove" : "[Remove]",
	"bye" : "[Bye]"
}

func _ready():
	season = 29
	load_state()
	SignalBus.openTable.emit()

func _process(delta: float):
	#report lag
	if (delta > 0.0167):
		if (delta < 0.0333): print("  ", delta) # <60 fps
		elif (delta < 0.1): print ("* ", delta) # <30 fps
		else: print("! ", delta) # <10 fps
	
static func getLevel(levelName): return Levels[levelName]
	
static func getSeason(): return season

static func save_state(softSave = true):
	print("^ saving")
	for level in Levels:
		Levels[level].saveToFile(softSave)

static func load_state():
	Levels["Prep"].loadData()
	SignalBus.doneLoading.emit()

static func getEntity_byName(entName: String, entDict: Dictionary) -> DataEntity:
	if Keyname.values().has(entName): return null
	for entID in entDict:
		var entity = entDict[entID]
		if entity.name == entName:
			return entity
	print("* entity with name " + entName + " not found")
	return null
