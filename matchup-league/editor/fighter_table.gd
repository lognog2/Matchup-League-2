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
	var new_row = row.duplicate()
	new_row.visible = true
	scroll_box.add_child(new_row)
	if (fighter):
		new_row.render_row(fighter)
	return new_row

func add_empty_row():
	message.visible = false
	add_row()
	
func save():
	message.visible = true
	scroll_box.save()
	super._save()
	render()

func update_message(msg = ""):
	message.text = msg
