extends Node

## selection filters
var Select = {
	TeamRanked = (func(t: Team): return t.rank > 0),
	Default = (func(_de): return true)
}


## sorting filters:
## if callable returns true, entity A will be closer to index 0 than entity B
var Sort = {
	# data entity
	Id = (func(a: DataEntity, b: DataEntity) -> bool: 
		return a.id < b.id),
	Alphabet = (func(a: DataEntity, b: DataEntity) -> bool:
		return a.de_name.naturalcasecmp_to(b.de_name) < 0),
	Rating = (func(a: DataEntity, b: DataEntity) -> bool:
		return a.get_rating() > b.get_rating()),
	WinPct = (func(a: DataEntity, b: DataEntity) -> bool:
		return a.win_pct() > b.win_pct()),
	Random = (func(_a, _b) -> bool:
		return randi() % 2 == 0),
	Default = (func(_a: DataEntity, _b: DataEntity) -> bool: 
		return false),

	# team
	TeamRank = (func(t1: Team, t2: Team) -> bool: 
		return (t1.rank > 0) && (t1.rank < t2.rank)),
	Record = (func(t1: Team, t2: Team) -> bool: 
		return t1.win_pct() > t2.win_pct()),
}

## similar to sorting filters, but returns a `Tribool` instead of a bool
var Compound = {
	Rating = (func(a: DataEntity, b: DataEntity) -> Tribool:
		return Tribool.compare(a.get_rating(), b.get_rating())),
	WinPct = (func(a: DataEntity, b: DataEntity) -> Tribool:
		return Tribool.compare(a.win_pct(), b.win_pct())),
}

## allows sorting by multiple filters: if A and B return tied in a filter,
## they are sorted by next filter instead
func compound_sort(filters: Array) -> Callable:
	return (func(a: Variant, b: Variant) -> bool:
		var result: Tribool = filters[0].call(a, b)
		if (result.is_neutral()):
			var new_filters = filters.duplicate()
			new_filters.pop_front()
			if (!new_filters.is_empty()):
				return compound_sort(new_filters).call(a, b)
		return result.get_bool()
	)

## returns true if `Game`'s round matches `r`
func select_by_round(r: int) -> Callable:
	return (func(g: Game): return g.rnd == r)

## filter to exclude self from selection
func exclude_self(obj_self: Object) -> Callable: 
	return (func(obj_comp: Object): return obj_self != obj_comp)
