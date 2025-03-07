extends Node

#done loading data from files
signal done_loading()

signal set_scene(scene_name: String)

signal to_game_select(t1: Team, t2: Team)
signal play_game(g: Game)

#open/close editor tables
signal open_table()
signal close_table()


signal user_set_game(r: int, target: Team, opp: Team)
