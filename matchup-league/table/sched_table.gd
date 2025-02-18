extends Table

@onready var message = $top_row/message
@onready var table = $scroll_box/table_vbox
@onready var blank_row = $scroll_box/table_vbox/table_hbox
@onready var blank_team_pane = $scroll_box/table_vbox/table_hbox/outer_mpane

var newRow: HBoxContainer

const rowLength = 14
const TEAM_GROUP = "team_boxes"

func _ready():
	if (!level): level = main.getLevel("Prep")
	message.visible = false
	blank_row.visible = false
	blank_team_pane.visible = false
	SignalBus.openTable.connect(render)
	SignalBus.user_set_game.connect(user_set_game)

func render():
	unload()
	add_row()
	var teams = level.get_teams_sorted(level.SORT_ALPHABET)
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
		elif(opponent && opponent.id == tbox.team.get_opponent(r)):
			print("^ removing ", tbox.team.id)
			tbox.set_game(r, null)

func save():
	#for tab_row in table.get_children():
	#	for team_pane in tab_row.get_children():
	#		var team_box = team_pane.get_child(0)
	#		if (team_box.team):
	#			team_box.save()
	queue_redraw()
	main.save_state()
	message.text = "Saved"
	message.visible = true
	
func updateMsg(msg = ""):
	message.text = msg
	
func hideMessage():
	message.visible = false
