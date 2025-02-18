extends HBoxContainer

var main = preload("res://main/main.gd")
var level: Level
const no_id = "-1"

@export var id: LineEdit
@export var f_name: LineEdit
@export var types: LineEdit
@export var base: SpinBox
@export var strType: OptionButton
@export var strVal: SpinBox
@export var wkType: OptionButton
@export var wkVal: SpinBox
@export var team: OptionButton
@export var startSeason: SpinBox

var teamID := -1

func _ready():
	level = main.getLevel("Prep")
	if (strType.item_count == 0):
		for idx in main.Types.keys():
			strType.add_item(main.Types[idx])
			wkType.add_item(main.Types[idx])
			

func openTeamList():
	team.clear()
	for id in level.teamDict:
		team.add_item(level.teamDict[id].name)

func closeTeamList():
	teamID = team.selected
	setTeam()
	
func setTeam():
	team.clear()
	if (teamID > -1):
		team.add_item(level.teamDict[teamID].name)
		team.selected = 0

func save():
	if (id.text == ""): id.text = no_id
	if (f_name.text == ""): return
	var data = {
		"id": id.text,
		"name": f_name.text.capitalize(),
		"season": main.getSeason(),
		"level": level.name,
		"types": types.text.to_upper(),
		"base": base.value,
		"strType": main.Types[strType.selected],
		"strVal": strVal.value,
		"wkType": main.Types[wkType.selected],
		"wkVal": wkVal.value,
		"start season": startSeason.value,
		"team ID": teamID
	}
	var newID
	if (id.text == no_id):
		newID = level.addNewFighter(data)
	else:
		newID = level.set_fighter(data)
	id.text = str(newID)

func load(f : Fighter):
	if (!level): level = main.getLevel("Prep")
	id.text = str(f.id)
	f_name.text = f.name
	types.text = f.types
	base.value = f.base
	strType.selected = main.Types.find_key(f.strType)
	strVal.value = f.strVal
	wkType.selected = main.Types.find_key(f.wkType)
	wkVal.value = f.wkVal
	startSeason.value = f.startSeason
	teamID = f.teamID
	setTeam()
