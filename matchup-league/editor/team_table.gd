extends Table

@export var scroll_box: Scrollable
@export var row: HBoxContainer
@export var message: Label

func _enter_tree():
	message.visible = false
	row.visible = false
	render()

func render():
	set_level()
	var row_list = []
	for t in level.get_teams():
		row_list.append(add_row(t))
	scroll_box.render(row_list)

func add_row(team: Team = null) -> Node:
	var new_row = row.duplicate()
	new_row.visible = true
	#table.add_child(new_row)
	if (team):
		new_row.load(team)
	return new_row
	
func add_empty_row():
	message.visible = false
	add_row()

func save():
	message.visible = true
	scroll_box.save()
	super._save()
	render()
