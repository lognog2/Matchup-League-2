extends Table

@export var table: VBoxContainer
@export var row: HBoxContainer
@export var message: Label
@export var softSave: CheckBox

func _enter_tree():
	#print("/ fighter table")
	message.visible = false
	row.visible = false
	render()

func render():
	unload()
	set_level("Prep")
	var dict = level.fighterDict
	for id in dict:
		add_row(dict[id])

func unload():
	for child in table.get_children():
		if (child.visible): child.queue_free()

func add_row(fighter: Fighter = null):
	var newRow = row.duplicate()
	table.add_child(newRow)
	newRow.visible = true
	if (fighter):
		newRow.render_row(fighter)

func add_empty_row():
	message.visible = false
	add_row()
	
func save():
	message.visible = true
	for t_row in table.get_children():
		t_row.save()
	Main.save_state(softSave.button_pressed)
	render()

func updateMsg(msg = ""):
	message.text = msg
