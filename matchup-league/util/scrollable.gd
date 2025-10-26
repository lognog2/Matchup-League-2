## scroll container that dynamically loads items as the user scrolls
class_name Scrollable extends ScrollContainer

var box: Container
var node_list: Array
var load_idx = 0
var load_amt = 25
var full = false

func _process(_delta):
	if (self.visible && !full):
		var scroll_bar = self.get_v_scroll_bar()
		if (((scroll_bar.max_value - scroll_bar.page) - scroll_bar.value) <= 0):
			add_batch()

func render(list: Array, initial_load = 25):
	if (!box):
		box = get_child(0)
	unload()
	node_list = list
	load_amt = initial_load
	

func unload():
	load_idx = 0
	full = false
	node_list = []
	for node in box.get_children():
		box.remove_child(node)

func add_batch():
	for i in range(0, load_amt):
		add_next()

func add_next():
	if (node_list.size() <= load_idx):
		full = true
		return
	box.add_child(node_list[load_idx])
	load_idx += 1
