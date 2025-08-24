class_name Reproducible extends Object
## reproducible queue of randomly generated ints

var rng: RandomNumberGenerator
var current_state: int
var queue: Queue

# TODO: rng is inconsistent when loading from a save file. either save number list or rework class
func _init(rseed = null, state = null):
	rng = RandomNumberGenerator.new()
	rng.randomize()
	rng.seed = rseed if (rseed) else rng.seed
	current_state = state if (state) else rng.state
	queue = Queue.new(100)
	reload()

func get_next() -> int:
	var next = queue.pop()
	if (!next):
		reload()
		return get_next()
	return next

func reload():
	if (queue.clear() != 0):
		Err.print_warn("remaining numbers were cleared from Reproducible on reload", Err.Warn.Runtime)
	for i in range(queue.capacity):
		queue.add(rng.randi())
		current_state = rng.state

func get_seed() -> int:
	return rng.seed

func get_state() -> int:
	return current_state

func print_seed():
	Err.print("/ %d" % get_seed())

func print_state():
	Err.print("/ %d" % get_state())
	
