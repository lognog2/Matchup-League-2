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
		row_list.append(create_row(t))
	scroll_box.render(row_list)
	
func create_row(team: Team = null) -> Node:
	var new_row = row.duplicate()
	new_row.visible = true
	if (team):
		new_row.load(team)
	return new_row

func add_row(team: Team = null) -> Node:
	var new_row = create_row(team)
	scroll_box.add_row(new_row)
	return new_row
	
func add_empty_row():
	message.visible = false
	add_row()

func save():
	message.visible = true
	scroll_box.save()
	super._save()
	render()
