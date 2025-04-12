extends Node

## implememnt in testing version
const test_message = "Please screenshot this message and show it to a dev"

## did not cpmplete
var Fatal = {
	Debug = -99, #placeholder
	Invalid = -6, #attempted to do action with incompatible data
	Conflict = -5, #data conflicts with program rules
	ReadWrite = -4, #error when interacting with files
	Insufficient = -3, #not enough data to complete task
	UI = -2, #error pertaining to ui
	Runtime = -1, #generic runtime error
	NoAction = 0 #no action was taken, and program cannot continue without it
}

## completed with unexpected behaviors
var Warn = {
	Debug = 99, #placeholder
	Invalid = 6, #attempted to do action with incompatible data but still completed
	Conflict = 5, #conflict that does not force program to stop
	Runtime = 1, #generic runtime warning
	NoAction = 0 #no action was taken, and it may be harmful to program
}

## completed as expected
var Success = {
	Debug = 99, #placeholder
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
	print_fatal(msg, code)
	alert(msg, "Error %d" % code)
	throw()

func alert_warn(msg = "", code = Warn.Debug):
	print_warn(msg, code)
	alert(msg, "Warning %d" % code)

func alert_success(msg = "", code = Success.Debug):
	print_success(msg, code)
	alert(msg, "Success %d" % code)
