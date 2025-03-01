extends Table

@export var table: VBoxContainer
@export var row: HBoxContainer
@export var message: Label

func _enter_tree():
	#print("/ team table")
	message.visible = false
	row.visible = false
	render()

func render():
	unload()
	var dict = Main.get_level("Prep").teamDict
	for id in dict:
		add_row(dict[id])
		
func unload():
	for child in table.get_children():
		if (child.visible): child.queue_free()

func add_row(team: Team = null):
	var newRow = row.duplicate()
	newRow.visible = true
	table.add_child(newRow)
	if (team):
		newRow.load(team)
	
func add_empty_row():
	message.visible = false
	add_row()

func save():
	for tr in table.get_children():
		tr.save()
	Main.save_state()
	message.text = "Saved"
	message.visible = true
	
func updateMsg(msg = ""):
	message.text = msg
	
func hideMessage():
	message.visible = false
