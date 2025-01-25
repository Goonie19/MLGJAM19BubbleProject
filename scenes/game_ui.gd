extends Control

@export var countdown:float = 3
@export var timer : Timer
@export var countdown_text : Label
@export var anim_player:AnimationPlayer

var current_time
var in_countdown

signal on_timer_completed

func _ready() -> void:
	current_time = countdown
	start_timer()

func _process(delta: float) -> void:
	if in_countdown:
		update_timer_text(current_time)

func start_timer():
	timer.wait_time = 1
	in_countdown = true	
	anim_player.stop()
	anim_player.play("countdown_anim")
	timer.start()

func continue_timer():	
	current_time -=1
	if current_time <= 0:
		in_countdown = false
		timer.start()
	else:
		timer.wait_time = 1
		anim_player.stop()
		anim_player.play("countdown_anim")
		timer.start()
		in_countdown = true

func update_timer_text(time:float):
	countdown_text.text = str(ceil(time))
