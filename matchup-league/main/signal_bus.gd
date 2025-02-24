extends Node

#done loading data from files
signal done_loading()

#open/close editor tables
signal open_table()
signal close_table()

signal set_scene(scene_name: String)

signal user_set_game(r: int, target: Team, opp: Team)
