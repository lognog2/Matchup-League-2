class_name FighterCard extends Control

@export var types: Label
@export var f_name: Label
@export var base: Label
@export var strength: Label
@export var weakness: Label
@export var team_name: Label
@export var contract: Label

var fighter: Fighter
var mouse_enter = false
var enable_click = false

var ResultColor = {
	Loss = Color.RED,
	Win = Color.GREEN,
	Tie = Color.BLUE
}

func _process(_delta: float):
	if (mouse_enter && Input.is_action_just_pressed('left_click')):
		SignalBus.user_select_fighter.emit(self)

func _ready():
	pass

func render(f: Fighter, enable = false):
	if (!f):
		print("! no fighter")
		return
	fighter = f
	types.text  = f.types_icon()
	f_name.text = f.name
	base.text = str(f.base)
	strength.text = f.mod_str(true)
	weakness.text = f.mod_str(false)
	team_name.text = f.team.name.left(3)
	enable_click = enable

func _enter():
	if (enable_click):
		mouse_enter = true

func _exit():
	mouse_enter = false

func render_win(str_app = false, wk_app = false):
	render_result(1, str_app, wk_app)

func render_loss(str_app = false, wk_app = false):
	render_result(0, str_app, wk_app)

func render_tie(str_app = false, wk_app = false):
	render_result(-1, str_app, wk_app)

## 0 for loss, 1 for win, -1 for tie
func render_result(result: int, str_app = false, wk_app = false):
	var base_val = int(base.text)
	if (str_app):
		base_val += int(strength.text)
	if (wk_app):
		base_val -= int(weakness.text)
	base.text = base_val
	base.font_color = ResultColor.values()[result]
