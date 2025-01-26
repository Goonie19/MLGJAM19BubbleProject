extends Control

class_name GameUI

@export var countdown:float = 3
@export var countdown_text : Label
@export var player_1_start_text: Label
@export var player_2_start_text: Label
@export var player_victory_text: Label
@export var anim_player:AnimationPlayer

@export var timer_text : Label
@export var player_1_Pfp : TextureRect
@export var player_2_Pfp : TextureRect

var current_time
var in_countdown

signal on_timer_completed
signal on_round_completed
signal on_game_finished

func _ready() -> void:
	on_timer_completed.connect(disable_in_countdown)

func start_timer():
	anim_player.stop()
	anim_player.play("countdown_anim")
	
func play_init_animation():
	anim_player.play("initial_state_menu")

func update_timer_text(time:float):
	countdown_text.text = str(ceil(time))

func update_player_texts(text_player_1, text_player_2):
	player_1_start_text.text = text_player_1
	player_2_start_text = text_player_2

func emit_on_countdown_finished():
	on_timer_completed.emit()
	
func play_ending_round():
	anim_player.play("finish_round_anim")

func emit_on_round_finished():
	on_round_completed.emit()

func disable_in_countdown():
	in_countdown = false

func set_player_victory_text(text):
	player_victory_text.text = text

func play_ending_anim():
	anim_player.play("end_anim")
	
func emit_round_completed():
	on_round_completed.emit()
	
func emit_ending_completed():
	on_game_finished.emit()
	

func set_time(time:float):
	timer_text.text = str(ceil(time))

func set_player_1_pfp(texture):
	player_1_Pfp.texture = texture
	
func set_player_2_pfp(texture):
	player_2_Pfp.texture = texture
