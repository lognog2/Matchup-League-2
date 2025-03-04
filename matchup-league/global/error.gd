extends Node

## did not cpmplete
var Fatal = {
	Debug = -11, #placeholder for debugging
	Conflict = -5, #data conflict
	ReadWrite = -4, #error when interacting with files
	Insufficient = -3, #not enough data to complete
	UI = -2, #error pertaining to ui
	Runtime = -1 #generic runtime error
}

## completed with unexpected behaviors
var Warn = {
	Conflict = 5,
	NoAction = 0
}

## completed as expected
var Success = {
	Success = 1,
	NoAction = 0
}
