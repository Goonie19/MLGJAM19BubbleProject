extends Node

@onready var spike_attack = $"Spike(attack)"
@onready var pom = $"../.."
@onready var animation_player = $"../../AnimationPlayer"
@export var pom_animation: AnimatedSprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("action_" + str(pom.player_num)):
		animation_player.play("attack")
		pom_animation.play("attack")
