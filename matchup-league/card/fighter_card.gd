extends Control

@export var types: Label
@export var f_name: Label
@export var base: Label
@export var strength: Label
@export var weakness: Label
@export var team_name: Label
@export var contract: Label

var fighter: Fighter

func _ready():
	pass

func render(f: Fighter):
	if (!f):
		print("! no fighter")
		return
	types.text  = f.types_str()
	f_name.text = f.name
	base.text = str(f.base)
	strength.text = f.mod_str(true)
	weakness.text = f.mod_str(false)
	team_name.text = f.team.name.left(3)
	fighter = f
