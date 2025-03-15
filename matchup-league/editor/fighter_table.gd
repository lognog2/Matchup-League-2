extends Table

@export var table: VBoxContainer
@export var row: HBoxContainer
@export var message: Label
@export var softSave: CheckBox

func _enter_tree():
	message.visible = false
	row.visible = false
	render()

func render():
	unload()
	set_level()
	for f in level.get_fighters():
		add_row(f)

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
