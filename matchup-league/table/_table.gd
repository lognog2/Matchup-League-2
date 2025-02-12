class_name Table extends Control

var main = preload("res://main/main.gd")

@export var tabContainer: TabContainer
@export var fighterTable: Table
@export var teamTable: Table

var tables = Array([fighterTable, teamTable])

#returns index of current tab
func getCurrentTab(): return tabContainer.current_tab

func getPage(tab: int): return tables[tab]

func newTab(tab: int):
	getPage(tab).render()
