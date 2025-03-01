extends "res://editor/fighter_table.gd"

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

func _enter_tree():
	if (strType.item_count == 0):
		for idx in Main.Types.keys():
			strType.add_item(Main.Types[idx])
			wkType.add_item(Main.Types[idx])
			

func openTeamList():
	team.clear()
	for i in level.teamDict:
		team.add_item(level.teamDict[i].name)

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
		"season": Main.get_season(),
		"level name": level.name,
		"types": types.text.to_upper(),
		"base": base.value,
		"strType": Main.Types[strType.selected],
		"strVal": strVal.value,
		"wkType": Main.Types[wkType.selected],
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
	if (!level): level = Main.get_level("Prep")
	id.text = str(f.id)
	f_name.text = f.name
	types.text = f.types
	base.value = f.base
	strType.selected = Main.Types.find_key(f.strType)
	strVal.value = f.strVal
	wkType.selected = Main.Types.find_key(f.wkType)
	wkVal.value = f.wkVal
	startSeason.value = f.startSeason
	teamID = f.teamID
	setTeam()
