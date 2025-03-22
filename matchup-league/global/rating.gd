extends Node

# fighter weights
var BASE_WT = 1
var TYPE_WT = 1.0 / Main.Types.size()
var STR_WT = TYPE_WT
var WK_WT = TYPE_WT

# team weights
var AVG_F_WT = 1
var WIN_WT = 30
var LOSS_WT = WIN_WT
var TIE_WT = round(WIN_WT / 2.0)
