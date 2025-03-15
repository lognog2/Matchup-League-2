extends Node

## selection filters
var Select = {
	Default = (func(_de): return true)
}

## sorting filters
var Sort = {
	Id = (func(a: DataEntity, b: DataEntity): 
		return a.id < b.id),
	Alphabet = (func(a: DataEntity, b: DataEntity): 
		return a.name.naturalcasecmp_to(b.name) < 0),
	Default = (func(_a: DataEntity, _b: DataEntity): 
		return false)
}

func exclude_self(obj_self: Object) -> Callable: 
	return func(obj_comp: Object): return obj_self != obj_comp
