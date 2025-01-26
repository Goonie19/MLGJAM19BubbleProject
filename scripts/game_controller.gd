extends Node2D
class_name GameController

@export var pom_start_string : String
@export var pa_start_string : String
@export var timer: Timer

@export var pom: Player
@export var player_1_pos: Node2D
@export var pa: Player
@export var player_2_pos: Node2D


@export var game_scene_ui : PackedScene

enum game_state_enum {inital_state, in_game, finished_game}

var current_state
var last_state

var ready_player_1 = false
var player_1_points = 0
var ready_player_2 = false
var player_2_points = 0
var end_round = false

var game_ui: GameUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_ui = game_scene_ui.instantiate()
	pom.set_game_controller(self)
	add_child(game_ui)
	game_ui.global_position = global_position
	game_ui.play_init_animation()
	last_state = game_state_enum.inital_state
	current_state = last_state
	game_ui.on_round_completed.connect(check_ending)
	
	set_players_pos()

func _process(delta: float) -> void:
	if current_state == game_state_enum.inital_state:
		check_initial_inputs()
		
		if ready_player_1 and ready_player_2:
			start_countdown()

#region = Initialize

func set_players_pos():
	if pom.player_num == 0:
		pom.position = player_1_pos.position
		pa.position = player_2_pos.position
	else:
		pom.position = player_2_pos.position
		pa.position = player_1_pos.position
		
	pom.togleMovement(false)
	pa.togleMovement(false)

func check_initial_inputs():
	if Input.is_action_just_pressed("jump_0"):
		ready_player_1 = true
	if Input.is_action_just_pressed("jump_1"):
		ready_player_2 = true

func set_state(state):
	current_state = state
	

#endregion

#region = countdown

func start_countdown():
	ready_player_1 = false
	ready_player_2 = false
	game_ui.on_timer_completed.connect(start_gameplay)
	game_ui.start_timer()

#endregion


#region = gameplay_state
func start_gameplay():
	current_state = game_state_enum.in_game
	game_ui.on_timer_completed.disconnect(start_gameplay)
	pom.togleMovement(true)
	pa.togleMovement(true)

func end_current_round():
	end_round = true
	timer.wait_time = 2
	timer.timeout.connect(restart_round)
	timer.start()
	
func restart_round():
	timer.timeout.disconnect(restart_round)
	set_players_pos()
	start_countdown()

func add_victory(player):
	if player == 0:
		player_1_points += 1
	else:
		player_2_points += 1
	
	
	play_victory_anim()

func play_victory_anim():
	game_ui.play_ending_round()

func check_ending():
	if player_1_points > 2:
		win_player_1()
	if player_2_points > 2:
		win_player_2()

#endregion

func pom_win_round():
	if pom.player_num == 0:
		win_player_1()
	else:
		win_player_2()

func win_player_1():
	game_ui.set_player_victory_text("Jugador 1 gana")
	game_ui.play_ending_anim()
	
func win_player_2():
	game_ui.set_player_victory_text("Jugador 2 gana")
	game_ui.play_ending_anim()
