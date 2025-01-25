extends Control

@export var countdown:float = 3
@export var countdown_text : Label
@export var player_1_start_text: Label
@export var player_2_start_text: Label
@export var anim_player:AnimationPlayer

var current_time
var in_countdown

signal on_timer_completed

func _ready() -> void:
	current_time = countdown
	on_timer_completed.connect(disable_in_countdown)
	start_timer()

func _process(delta: float) -> void:
	if in_countdown:
		update_timer_text(current_time)

func start_timer():
	in_countdown = true
	anim_player.play("countdown_anim")

func update_timer_text(time:float):
	countdown_text.text = str(ceil(time))

func update_player_texts(text_player_1, text_player_2):
	player_1_start_text.text = text_player_1
	player_2_start_text = text_player_2

func emit_on_countdown_finished():
	on_timer_completed.emit()

func disable_in_countdown():
	in_countdown = false
