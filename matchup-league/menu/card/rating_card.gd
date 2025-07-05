extends Card

@export var vbox: Container

var blank_rating_box: Container
var FORMAT_FLOAT = "%+.1f"
var FORMAT_INT = "%+d"
const OFFSET = Vector2(20.0, 0)

func _ready():
	SignalBus.get_rating_breakdown.connect(render)
	blank_rating_box = NodeUtil.detach_child(vbox)
	visible = false

func render(dict: Dictionary):
	if (visible || dict.is_empty()):  
		visible = false
		return
	
	NodeUtil.move_to_mouse(self, OFFSET)
	NodeUtil.remove_children(vbox)

	for rating_name in dict.keys():
		var val = dict[rating_name]
		var format = FORMAT_INT if (val is int) else FORMAT_FLOAT
		render_rating(rating_name, format % val)

	visible = true

func render_rating(label: String, value: String):
	var new_box = blank_rating_box.duplicate()
	new_box.get_child(0).text = label
	new_box.get_child(1).text = value
	vbox.add_child(new_box)
	new_box.visible = true
