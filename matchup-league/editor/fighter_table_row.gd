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

var teamID = -1
var fighter: Fighter

func _enter_tree():
	pass

func render_row(f : Fighter):
	fighter = f
	fill_mod_obs()
	if (!level): level = Main.get_level("Prep")
	id.text = str(f.id)
	f_name.text = f.de_name
	types.text = f.types_str()
	base.value = f.base
	strType.selected = find_item_idx(strType, Main.Types.find_key(f.strType))
	strVal.value = f.strVal
	wkType.selected = find_item_idx(wkType, Main.Types.find_key(f.wkType))
	wkVal.value = f.wkVal
	startSeason.value = f.startSeason
	teamID = f.teamID
	setTeam()

##fill option buttons for strength and weakness types
func fill_mod_obs():
	if (strType.item_count == 0):
		for i in range (Main.Types.size()):
			var type_name = Main.Types.keys()[i]
			strType.add_item(type_name)
			wkType.add_item(type_name)
	
			
func openTeamList():
	team.clear()
	for t in level.get_t_names():
		team.add_item(t)

func closeTeamList():
	teamID = team.selected
	setTeam()
	
func setTeam():
	team.clear()
	if (teamID > -1):
		team.add_item(level.get_team(teamID).de_name)
		team.selected = 0

## returns index of text in option button, or -1 if not found
func find_item_idx(ob: OptionButton, find: String) -> int:
	for i in range (ob.item_count):
		if (find == ob.get_item_text(i)):
			return i
	return -1

func save():
	if (id.text == ""): id.text = no_id
	if (f_name.text == ""): return
	var data = {
		"id": id.text,
		"name": f_name.text,
		"season": Main.get_season(),
		"level name": level.name,
		"types": types.text,
		"base": base.value,
		"strType": Main.Types[strType.get_item_text(strType.selected)],
		"strVal": strVal.value,
		"wkType": Main.Types[wkType.get_item_text(wkType.selected)],
		"wkVal": wkVal.value,
		"start season": startSeason.value,
		"team ID": teamID
	}
	if (id.text == no_id):
		level.add_fighter(data) 
		#id.text = str(newID)
	else:
		level.set_fighter(data)
