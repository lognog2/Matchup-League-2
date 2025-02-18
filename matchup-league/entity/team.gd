class_name Team extends DataEntity

var fighters = Array()
var schedule: Dictionary
var color

func _init(data: Dictionary):
	super(data)
	color = data["color"]
	for r in data["schedule"]:
		var oppID = data["schedule"][r]
		schedule[int(r)] = oppID if oppID != null else -1

func addFighter(f: Fighter):
	fighters.append(f)
	
func add_game(r: int, oppID: int, setOpp = true):
	print("/ add game " + str(id) + " " + str(oppID) + " " + str(setOpp))
	if (oppID < 0): 
		remove_game(r, setOpp)
		return
	schedule[r] = oppID
	if (!setOpp): return
	var opp = level.get_team(oppID)
	if (opp.get_opponent(r) != id):
		if (opp.has_game(r)): 
			opp.remove_game(r)
		opp.add_game(r, id, false)

func remove_game(r: int, remOpp = true):
	print("/ remove game " + str(id) + " " + str(remOpp))
	if (!has_game(r)): return
	if (!remOpp):
		schedule[r] = -1
		return
	var opp = level.get_team(get_opponent(r))
	schedule[r] = -1
	if (opp.get_opponent(r) == id):
		opp.remove_game(r, false)

func get_game(r: int) -> int:
	return get_opponent(r)

func get_opponent(r: int) -> int:
	return schedule[r]

func has_game(r: int) -> bool:
	return get_opponent(r) >= 0
	

# debug functions

func check_sync(r) -> bool:
	if (!has_game(r)): return true
	return id == level.get_team(get_opponent(r)).get_opponent(r)

# saving functions

func format_save() -> Dictionary:
	var data = {
		"id": id,
		"name": name,
		"season": season,
		"color": color,
		"schedule": schedule
	}
	return data
