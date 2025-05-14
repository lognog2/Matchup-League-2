## a bool-like class, except it can have one of three values: true, false, or neutral
class_name Tribool extends Object

enum {False = -1, True = 1, Neutral = 0}

var state = Neutral

func _init(st = Neutral):
	state = st

# returns this object as a bool. `neutral_lean` determines which way neutral is interpreted
func get_bool(neutral_lean = false) -> bool:
	match (state):
		True: return true
		False: return false
		Neutral: return neutral_lean
		_: 
			Err.alert_fatal("tribool state is invalid", Err.Fatal.Invalid)
			return false

func is_true() -> bool:
	return state == True

func is_false() -> bool:
	return state == False

func is_neutral() -> bool:
	return state == Neutral

func flip():
	if (is_true()): state = False
	elif (is_false()): state = True

## makes `Tribool` from: -1 for `False`, 1 for `True`, 0 for `Neutral`
static func from_int(i: int) -> Tribool:
	match i:
		1: return Tribool.new(True)
		-1: return Tribool.new(False)
		0: return Tribool.new(Neutral)
		_:
			Err.alert_fatal("tribool int is invalid", Err.Fatal.Invalid)
			return null

## makes `Tribool` from bool value
static func from_bool(b: bool) -> Tribool:
	var st = True if (b) else False
	return Tribool.new(st)

## returns `True` if `v1`>`v2`, `False` if `v1`<`v2`, `Neutral` if equal (or approx. equal for floats)
static func compare(v1: Variant, v2: Variant) -> Tribool:
	if (v1 == v2 || is_equal_approx(v1, v2)):
		return Tribool.new(Neutral)
	if (v1 > v2):
		return Tribool.new(True)
	if (v1 < v2):
		return Tribool.new(False)
	print("? how did you get here")
	return null
