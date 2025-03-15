extends Node

## did not cpmplete
var Fatal = {
	Debug = -99, #placeholder for debugging
	Invalid = -6, #attempted to do action with incompatible data
	Conflict = -5, #data conflict
	ReadWrite = -4, #error when interacting with files
	Insufficient = -3, #not enough data to complete
	UI = -2, #error pertaining to ui
	Runtime = -1, #generic runtime error
	NoAction = 0 #no action was taken, and program cannot continue without it
}

## completed with unexpected behaviors
var Warn = {
	Debug = 99, #placeholder for debugging
	Conflict = 5, #conflict that does not force program to stop
	NoAction = 0 #no action was taken, and it may be harmful to program
}

## completed as expected
var Success = {
	Debug = 99, #placeholder for debugging
	Success = 1, #completed as expected
	NoAction = 0 #no action was taken, and program can reliably continue
}

## stops program by calling nonexistent function
func throw():
	print(Err.a)

func print(msg = ""):
	print(msg)

func print_fatal(msg = "", code = Fatal.Debug):
	print("! Error %d: " % code, msg)
	throw()

func print_warn(msg = "", code = Warn.Debug):
	print("* Warning %d: " % code, msg)

func print_success(msg = "", code = Success.Debug):
	print("  Success %d: " % code, msg)

func alert(msg = "", title = ""):
	OS.alert(msg, title)

func alert_fatal(msg = "", code = Fatal.Debug):
	alert(msg, "Error %d" % code)
	throw()

func alert_warn(msg = "", code = Warn.Debug):
	alert(msg, "Warning %d" % code)

func alert_success(msg = "", code = Success.Debug):
	alert(msg, "Success %d" % code)
