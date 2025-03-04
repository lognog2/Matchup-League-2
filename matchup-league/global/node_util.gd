## Convenience functions for control nodes
extends Node

## calls `queue_free()` on each child of this node
func remove_children(node: Node):
	for child in node.get_children():
		child.queue_free()
