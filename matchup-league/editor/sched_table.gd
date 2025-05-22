extends Table

@export var message: Label
@export var table: VBoxContainer
@export var blank_row: HBoxContainer
@export var blank_team_pane: MarginContainer

var newRow: HBoxContainer

const rowLength = 14
const TEAM_GROUP = "team_boxes"

func _enter_tree():
	#print("/ sched table")
	message.visible = false
	blank_row.visible = false
	blank_team_pane.visible = false
	set_level()
	render()

func render():
	unload()
	add_row()
	var teams = level.get_teams_sorted(Filter.Sort.Alphabet)
	for t in teams:
		add_team(t) 
		
func unload():
	for child in blank_row.get_children():
		if (child.visible): child.queue_free()

func add_row():
	newRow = blank_row.duplicate()
	table.add_child(newRow)
	newRow.visible = true

func add_team(team: Team):
	if (!team): return
	if (newRow.get_child_count() >= rowLength):
		add_row()
	var newTeamPane = blank_team_pane.duplicate()
	newRow.add_child(newTeamPane)
	var newTeamBox = newTeamPane.get_child(0)
	newTeamBox.set_team(team)
	newTeamPane.visible = true
	
func add_empty_row():
	message.visible = false
	add_row()

func get_team_boxes():
	return get_tree().get_nodes_in_group(TEAM_GROUP)

func user_set_game(r: int, target: Team, opponent: Team):
	for tbox in get_team_boxes():
		if (target == tbox.team):
			#print("^ adding ", tbox.team.id)
			tbox.set_game(r, opponent)
		elif(opponent && opponent == tbox.team.get_opponent(r)):
			#print("^ removing ", tbox.team.id)
			tbox.set_game(r, null)

func save():
	#for tab_row in table.get_children():
	#	for team_pane in tab_row.get_children():
	#		var team_box = team_pane.get_child(0)
	#		if (team_box.team):
	#			team_box.save()
	queue_redraw()
	super._save()
