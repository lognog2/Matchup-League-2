class_name Reproducible extends Object
## reproducible queue of randomly generated ints

var rng: RandomNumberGenerator
var next_state: int
var queue: Queue

func _init(rseed = null, state = null):
	rng = RandomNumberGenerator.new()
	rng.randomize()
	rng.seed = rseed if (rseed) else rng.seed
	next_state = state if (state) else rng.state
	#Err.print(str(next_state))
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
	rng.state = next_state
	for i in range(queue.capacity):
		queue.add(rng.randi())
	next_state = rng.state

func get_seed() -> int:
	return rng.seed

func get_state() -> int:
	return next_state
