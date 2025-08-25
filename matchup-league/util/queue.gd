class_name Queue extends Object

var capacity: int
var queue = []
var last_pop: Variant

func _init(cap = 100):
	capacity = cap

## adds `v` to end of queue,
## returns true if `v` was added successfully
func add(v: Variant, push_front = true) -> bool:
	if (size() == capacity):
		if (push_front): 
			queue.append(v)
			pop()
		return push_front
	queue.append(v)
	return true

## returns and removes var in the front of the queue, or null if queue is empty
func pop() -> Variant:
	last_pop = queue.pop_front()
	return last_pop

## adds variants from `bulk` one at a time,
## returns true if all vars were added, or false if a var did not get added
func fill(bulk: Array, push_front = true) -> bool:
	for v in bulk:
		var added = add(v, push_front)
		if (!added): return false
	return true

## pops `amt` vars from queue, one at a time.
## returns array of removed vars, in the order they were removed
func drain(amt: int, add_null = false) -> Array:
	var out = []
	for i in range(amt):
		var next = pop()
		if (next || add_null): out.append(next)
	return out

func size() -> int:
	return queue.size()

func is_empty() -> bool:
	return queue.is_empty()

## completely clears queue, returns size of queue before clearing
func clear() -> int:
	var sz = size()
	#Err.print("^ cleared %d items from queue" % sz)
	queue.clear()
	return sz
