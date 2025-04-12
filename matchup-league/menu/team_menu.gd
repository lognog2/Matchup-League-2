extends Menu

@export var team_option: OptionButton
@export var sort_option: OptionButton
@export var team_view: TeamView
@export var selected_label: Label

var FilterList = {
	Alphabet = Filter.Sort.Alphabet,
	Rating = Filter.Sort.Rating,
}
var team: Team
var selected_index = -1
var filter = FilterList.Alphabet

func _ready():
	SignalBus.to_team_menu.connect(render)

func render(t: Team = null):
	team = t
	team_view.render(team)
	fill_team_dropdown()
	fill_filter_dropdown()
	selected_label.text = str(selected_index + 1)

func fill_team_dropdown():
	team_option.clear()
	for t in level.get_teams_sorted(filter):
		team_option.add_item(t.de_name)
		if (t.de_name == team.de_name):
			selected_index = team_option.item_count - 1
	team_option.selected = selected_index

func fill_filter_dropdown():
	sort_option.clear()
	for i in range (FilterList.size()):
		var filter_name = FilterList.keys()[i]
		sort_option.add_item(filter_name)
		if (FilterList.values()[i] == filter):
			sort_option.selected = i

func render_selected_team():
	var t_name = team_option.get_item_text(selected_index)
	var new_team = team.level.find_team(t_name)
	render(new_team)

func _select_team(idx: int):
	selected_index = idx
	render_selected_team()

func _next():
	selected_index += 1
	if (selected_index >= team_option.item_count):
		selected_index = 0
	render_selected_team()
	
func _prev():
	selected_index -= 1
	if (selected_index < 0):
		selected_index = team_option.item_count - 1
	render_selected_team()

func _select_filter(idx: int):
	filter = FilterList.values()[idx]
	render(team)
