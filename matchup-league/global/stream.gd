extends Node

var queue_arr = []
var cache_arr = []

var interval = 1

var counter = 0
var MAX_COUNTER = 9999

func _process(_delta: float):
	if (!queue_arr.is_empty()):
		for i in range (interval):
			pop_queue()
		return
	cache_call()
	counter += 1
	if (counter > MAX_COUNTER):
		counter = 0

## calls first func in queue and pops it from queue
func pop_queue():
	if (!queue_arr.is_empty()):
		queue_arr.pop_front().call()

func queue_into_arr(function: Callable, insert: int, arr: Array):
	if (!function): 
		Err.print("* tried to add null callable to stream")
		return
	if (insert >= 0 && insert <= arr.size()):
		arr.insert(insert, function)
	else:
		arr.push_back(function)

## adds a no-parameters func to the stream queue
func queue(function: Callable, insert = -1):
	queue_into_arr(function, insert, queue_arr)

## adds a group of funcs to queue
func queue_group(arr: Array):
	for callable: Callable in arr:
		queue(callable)
	
## adds a func to the cache
func cache(function: Callable, insert = -1):
	queue_into_arr(function, insert, cache_arr)

## adds a group of funcs to cache
func cache_group(arr: Array):
	for callable: Callable in arr:
		cache(callable)

## instantly calls all funcs in cache, in the order they were added
func cache_call():
	for function: Callable in cache_arr:
		function.call()
	cache_arr.clear()	

## queues all funcs in cache and clears it
func queue_cache():
	queue_group(cache_arr)
	cache_arr.clear()

func str_counter() -> String:
	return "%04d " % counter
