## intercepts signals and prints them
extends Node

const CHAR = ">"
var enabled = false

func _ready():
	if (!enabled): return
	SignalBus.done_loading.connect(done_loading)
	SignalBus.set_scene.connect(set_scene)
	SignalBus.to_game_select.connect(game_select)
	SignalBus.to_career_select.connect(career_select)

	SignalBus.run_match.connect(run_match)

func done_loading():
	print_signal("done loading")

func set_scene(sc: String):
	print_signal("set scene %s" % sc)

func game_select(t1: Team, t2: Team):
	print_signal("to game select (%s, %s)" % [t1.de_name, t2.de_name])

func career_select():
	print_signal("to career select")


func run_match(f1: Fighter, f2: Fighter):
	print_signal("run match (%s, %s)" % [f1.de_name, f2.de_name])

func print_signal(message: String):
	if (!enabled): return
	print("%s %s" % [CHAR, message])
