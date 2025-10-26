extends Table

@export var scroll_box: Scrollable
@export var row: HBoxContainer
@export var message: Label
@export var backup: CheckBox

func _enter_tree():
	message.visible = false
	row.visible = false
	render()

func render():
	set_level()
	var row_list = []
	for f in level.get_fighters():
		row_list.append(add_row(f))
	scroll_box.render(row_list)

func add_row(fighter: Fighter = null) -> Node:
	var newRow = row.duplicate()
	newRow.visible = true
	if (fighter):
		newRow.render_row(fighter)
	return newRow

func add_empty_row():
	message.visible = false
	add_row()
	
func save():
	message.visible = true
	for t_row in scroll_box.box.get_children():
		t_row.save()
	Main.save_state(backup.button_pressed)
	render()

func updateMsg(msg = ""):
	message.text = msg
