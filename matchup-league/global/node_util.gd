## Convenience functions for control nodes
extends Node
	
const STYLE_BOX_BG = "background"

func float_zero() -> float:
	return 1.000 - 1.000

## label.add_theme_color_override("font_color", color)
func set_label_color(label: Label, color: Color):
	label.add_theme_color_override("font_color", color)

## takes a node's first child, duplicates it, removes node's children, then returns detached child.
func detach_child(parent: Node) -> Node:
	if (!parent):
		Err.alert_warn("Cannot reparent a null node", Err.Warn.NoAction)
		return null
	var child = parent.get_child(0).duplicate()
	remove_children(parent)
	return child

## calls `queue_free()` on each child of this node
func remove_children(node: Node):
	for child in node.get_children():
		child.queue_free()

## set `recursion` to -1 to reverse all children
func reverse_children(node: Node, recursion = 0):
	var a = 0
	var z = node.get_child_count()
	while (a < z):
		node.move_child(node.get_child(a), z)
		node.move_child(node.get_child(z), a)
		a += 1
		z -= 1
	if (recursion == 0 || node.get_child_count() == 0): return
	for child in node.get_children():
		reverse_children(child, recursion - 1)

## assumes node has only `FighterCard` children, repopulates node with `list`
func list_fighter_cards(node: Node, list: Array):
	var blank_fc = detach_child(node)
	if (!blank_fc is FighterCard): Err.print_fatal("not a fighter card", Err.Fatal.UI)
	for f: Fighter in list:
		var new_fc = blank_fc.duplicate()
		new_fc.render(f)
		node.add_child(new_fc)

func compare_colors(color1: Color, color2: Color) -> bool:
	var color1_hex = color1.to_rgba32()
	var color2_hex = color2.to_rgba32()
	return (color1_hex == color2_hex)

func load_style(style_name: String, ext = ".tres"):
	var path = "res://style/" + style_name + ext
	var style = load(path)
	return style

func set_bg_theme(style_name = STYLE_BOX_BG, color: Color = Setting.s.theme):
	var bg_box = NodeUtil.load_style(style_name)
	if (!bg_box): Err.print_fatal("No stylebox found", Err.Fatal.UI)
	bg_box.bg_color = color
