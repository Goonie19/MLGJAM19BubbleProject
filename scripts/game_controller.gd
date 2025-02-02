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

@export var music_player: MusicController
@export var menu_music : AudioStream
@export var round_music_array : Array[AudioStream]

enum game_state_enum {inital_state, in_game, finished_game}

var current_state
var last_state

var ready_player_1 = false
var player_1_points = 0
var ready_player_2 = false
var player_2_points = 0

var game_ui: GameUI

var current_round: int = 0

var on_countdown = false

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
	game_ui.on_game_finished.connect(reload_game)
	
	music_player.stream = menu_music
	music_player.play()
	
	set_players_pos()

func _process(delta: float) -> void:
	if on_countdown:
		game_ui.set_time(timer.time_left)
	
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
	on_countdown = true
	game_ui.on_timer_completed.connect(start_gameplay)
	game_ui.start_timer()

#endregion


#region = gameplay_state
func start_gameplay():
	current_state = game_state_enum.in_game
	game_ui.on_timer_completed.disconnect(start_gameplay)
	pom.togleMovement(true)
	pa.togleMovement(true)
	music_player.stream = round_music_array[current_round]
	music_player.play()
	timer.wait_time = 10
	timer.timeout.connect(pa_win_round)
	timer.start()

func end_current_round():
	on_countdown = false
	#music_player.stop_music()
	current_round += 1
	timer.wait_time = 2
	timer.timeout.connect(restart_round)
	timer.start()
	
func restart_round():
	timer.timeout.disconnect(restart_round)
	pom.onFinalState = false
	pa.onFinalState = false
	var player = pom.player_num
	if player == 0:
		pom.player_num = 1
		pa.player_num = 0
		game_ui.set_player_1_pfp(pa.character_texture)
		game_ui.set_player_2_pfp(pom.character_texture)
	else:
		pom.player_num = 0
		pa.player_num = 1
		game_ui.set_player_1_pfp(pom.character_texture)
		game_ui.set_player_2_pfp(pa.character_texture)
	
	set_players_pos()
	start_countdown()

func add_victory(player):
	if player == 0:
		game_ui.set_round_won(player, player_1_points)
		player_1_points += 1
	else:
		game_ui.set_round_won(player, player_2_points)

		player_2_points += 1
	
	
	play_victory_anim()

func play_victory_anim():
	game_ui.play_ending_round()

func check_ending():
	if player_1_points > 2:
		win_player_1()
		return
	if player_2_points > 2:
		win_player_2()
		return
	
	end_current_round()
		
	

#endregion

func pom_win_round():
	if pom.player_num == 0:
		win_player_1_round()
	else:
		win_player_2_round()
		
	pom.playWin()
	pa.playDefeat()
	timer.timeout.disconnect(pa_win_round)
	timer.stop()

func pa_win_round():
	if pa.player_num == 0:
		win_player_1_round()
	else:
		win_player_2_round()
		
		
	pom.playDefeat()
	pa.playWin()
	timer.timeout.disconnect(pa_win_round)

func win_player_1_round():
	game_ui.set_player_victory_text("Sacabó")
	add_victory(0)
	pom.togleMovement(false)
	pa.togleMovement(false)
	

func win_player_1():
	game_ui.play_ending_anim()

func win_player_2_round():
	game_ui.set_player_victory_text("Sacabó")
	add_victory(1)
	pom.togleMovement(false)
	pa.togleMovement(false)

func win_player_2():
	game_ui.play_ending_anim()

func reload_game():
	get_tree().reload_current_scene()
