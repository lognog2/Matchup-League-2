extends Node

#done loading data from files
signal doneLoading()

#open/close edit tables
signal openTable()
signal closeTable()

signal user_set_game(r: int, target: Team, opp: Team)
