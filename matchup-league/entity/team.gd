class_name Team extends DataEntity

var fighters = Array()
var schedule: Dictionary
var color

func _init(data: Dictionary):
	super(data)
	color = data["color"]
	#schedule = data["schedule"]
	for i in range (7):
		schedule[i] = -1

func addFighter(f: Fighter):
	fighters.append(f)
	
func format_save():
	var data = {
		"id": id,
		"name": name,
		"season": season,
		"color": color,
		"schedule": schedule
	}
	return data
