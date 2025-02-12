extends Table

@onready var message = $top_row/message
@onready var table = $scroll_box/table
@onready var row = $scroll_box/table/row
@onready var team_box = $scroll_box/table/row/team_box

var newRow: HBoxContainer

const rowLength = 10

func _ready():
	message.visible = false
	row.visible = false
	team_box.visible = false
	SignalBus.openTable.connect(render)

func render():
	unload()
	add_row()
	var teams = main.getLevel("Prep").getTeamsSorted()
	for t in teams:
		add_team(t)
		
func unload():
	for child in row.get_children():
		if (child.visible): child.queue_free()

func add_row():
	newRow = row.duplicate()
	table.add_child(newRow)
	newRow.visible = true

func add_team(team: Team):
	if (newRow.get_child_count() >= rowLength):
		add_row()
	var newTeam = team_box.duplicate()
	newRow.add_child(newTeam)
	newTeam.setTeam(team)
	newTeam.visible = true
	
func add_empty_row():
	message.visible = false
	add_row()

func save():
	for tab_row in table.get_children():
		for teambox in tab_row.get_children():
			teambox.save()
	main.saveState()
	message.text = "Saved"
	message.visible = true
	
func updateMsg(msg = ""):
	message.text = msg
	
func hideMessage():
	message.visible = false
