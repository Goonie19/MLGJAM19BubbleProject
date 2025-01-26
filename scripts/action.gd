extends Node

class_name Action

@onready var spike_attack = $"Spike(attack)"
@onready var pom = $"../.."
@onready var animation_player = $"../../AnimationPlayer"
@export var pom_animation: AnimatedSprite2D
@export var actionAnimation: String

func doAction():
	animation_player.play(actionAnimation)
	pom_animation.stop()
	pom_animation.play(actionAnimation)
