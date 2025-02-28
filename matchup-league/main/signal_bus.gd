extends Node

#done loading data from files
signal done_loading()

signal set_scene(scene_name: String)

signal do_game(t1: Team, t2: Team)

#open/close editor tables
signal open_table()
signal close_table()


signal user_set_game(r: int, target: Team, opp: Team)
