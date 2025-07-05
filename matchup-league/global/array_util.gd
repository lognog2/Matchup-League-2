extends Node

## calls `function` once on each element of `arr`. `function` should be a func(e) where e is any variant in `arr`
func for_each(arr: Array, function: Callable):
	for e in arr:
		function.call(e)

##returns sum of elements in `arr` as a float
func sum(arr: Array) -> float:
	var total = 0
	for n in arr:
		total += float(n)
	return total

func map_dict(dict: Dictionary, function: Callable) -> Dictionary:
	var new_dict = dict.duplicate()
	for k in dict.keys():
		var v = function.call(k)
		new_dict[k] = v
	return new_dict
