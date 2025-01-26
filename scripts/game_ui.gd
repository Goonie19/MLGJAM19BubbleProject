extends Control

class_name GameUI

@export var countdown:float = 3
@export var countdown_text : Label
@export var player_1_start_text: Label
@export var player_2_start_text: Label
@export var anim_player:AnimationPlayer

var current_time
var in_countdown

signal on_timer_completed

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

func disable_in_countdown():
	in_countdown = false
