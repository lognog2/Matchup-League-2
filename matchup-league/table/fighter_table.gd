extends Table

signal updateMessage(msg)

@export var table: VBoxContainer
@export var row: HBoxContainer
@export var message: Label
@export var softSave: CheckBox

func _ready():
	message.visible = false
	row.visible = false
	updateMessage.connect(updateMsg)
	SignalBus.openTable.connect(render)

func render():
	unload()
	var dict = main.getLevel("Prep").fighterDict
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
		newRow.load(fighter)

func add_empty_row():
	message.visible = false
	add_row()
	
func save():
	updateMessage.emit("Saving")
	message.visible = true
	for tr in table.get_children():
		tr.save()
	main.saveState(softSave.button_pressed)
	render()
	updateMessage.emit("Saved")

func updateMsg(msg = ""):
	message.text = msg

func hideMessage():
	updateMessage.emit("")
