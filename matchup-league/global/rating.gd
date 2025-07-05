extends Node

enum Scale {
	NONE = 1,
	LOW = 50,
	MEDIUM = 75,
	HIGH = 100,
}

# fighter weights
var BASE_WT = 0.1
var TYPE_WT = 1.0 / Main.Types.size()
var STR_WT = TYPE_WT
var WK_WT = TYPE_WT

# team weights
var AVG_F_WT = 1
var WIN_WT = 25
var LOSS_WT = 0
var TIE_WT = round(WIN_WT / 2.0)
