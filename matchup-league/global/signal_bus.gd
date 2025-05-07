extends Node

#done saving/loading data from files
signal done_saving()
signal done_loading()

signal set_scene(scene_name: String)

signal to_game_select(t1: Team, t2: Team)
signal to_career_select()
signal to_team_menu(t: Team)
#signal to_season_menu(before: bool)
signal play_game(g: Game, replay: bool)
signal game_end(winner: Team)

#open/close editor tables
signal open_table()
signal close_table()

signal run_match(f1: Fighter, f2: Fighter)

signal user_set_game(r: int, target: Team, opp: Team)

signal user_select_fighter(fc: FighterCard)
