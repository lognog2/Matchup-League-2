class_name FighterCard extends Card

@export var card_color_rect: ColorRect
@export var types: Label
@export var f_name: Label
@export var base: Label
@export var strength: Label
@export var weakness: Label
@export var team_name: Label
@export var matches: Label

var fighter: Fighter
var mouse_enter = false
var enable_click = false

func _process(_delta: float):
	if (mouse_enter && Input.is_action_just_pressed('left_click')):
		SignalBus.user_select_fighter.emit(self)

func _ready():
	card_color_rect.color = Color.WHITE

func render(f: Fighter, enable = false):
	if (!f):
		Err.print_warn("* no fighter", Err.Warn.NoAction)
		return
	fighter = f
	types.text  = f.types_icon()
	f_name.text = f.de_name
	base.text = str(f.base)
	strength.text = f.str_mod(true)
	weakness.text = f.str_mod(false)
	team_name.text = f.team.str_name_abbr()
	matches.text = f.str_matches()
	enable_click = enable
	show_info()

func show_info():
	types.get_parent().visible = true

func hide_info():
	types.get_parent().visible = false

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
		NodeUtil.set_label_color(strength, ResultColor.Win)
	if (wk_app):
		base_val += int(weakness.text) #minus sign from text included
		NodeUtil.set_label_color(weakness, ResultColor.Loss)
	base.text = str(base_val)
	var col = ResultColor.values()[result]
	NodeUtil.set_label_color(base, col)
	if (result != 1):
		card_color_rect.color = Color.LIGHT_GRAY

func _enter():
	#print("/ enter")
	if (enable_click):
		#print("/ true")
		mouse_enter = true

func _exit():
	#print("/ exit " + str(enable_click))
	mouse_enter = false
