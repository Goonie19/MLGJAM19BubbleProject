extends Node2D

@export var pom_start_string : String
@export var pa_start_string : String

@export var pom: Player
@export var pa: Player

@export var game_scene_ui : PackedScene

enum game_state_enum {inital_state, in_game, finished_game}

var current_state
var last_state


var game_ui: GameUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_ui = game_scene_ui.instantiate()
	add_child(game_ui)
	game_ui.global_position = global_position
	game_ui.play_init_animation()
	last_state = game_state_enum.inital_state
	current_state = last_state

func check_initial_inputs():
	if pom.player_num == 0:
		pass
	else:
		pass

func set_state(state):
	current_state = state
