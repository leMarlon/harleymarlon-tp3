extends Node

var player_current_attack = false
var found_oldman_item = false
var given_oldman_item = false
var quest_begun = false
var obtained_pickaxe = false
var chosen_yes_break_boulder = false

var current_scene = "world"
var transition_scene = false

var player_exit_cliffside_posx = 771.0
var player_exit_cliffside_posy = 48.0

var player_start_posx = 89.0
var player_start_posy = 112.0

var game_first_loadin = true
var game_outof_cliffside = false

func finish_changescenes():
	transition_scene = false
	if current_scene == "world":
		current_scene = "cliff_side"
	elif current_scene == "cliff_side":
		current_scene = "world"
