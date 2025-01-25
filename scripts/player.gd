extends CharacterBody2D

@export var player_num: int = 0
@export var speed: float = 300.0
@export var jump_velocity = -400.0
@export var fallMod: float = 2 #Multiplica al caer (para que caiga mas rápido)
@export var localGravityScale: float = 6
@export var jumpBufferTime: float = 1
@export var coyoteTime: float = 0.05

@onready var coyote_timer = $CoyoteTimer

var jumpTimeRemaining: float = 0
var onCoyoteTime: bool = false
var canJump: bool = false

func _process(delta):
	doCoyoteTime()
	jumpBuffer(delta)
	if Input.is_action_just_released("jump_" + str(player_num)) and velocity.y < 0:
		velocity.y /= 4
	
func _physics_process(delta: float) -> void:	
	applyJumpGravity(delta)
	move_player()
	move_and_slide()
	
func applyJumpGravity(delta: float):
	# Add the gravity.
	if not is_on_floor():
		var mod = 1;
		if velocity.y > 0:
			#Baja
			mod = fallMod
		
		velocity += get_gravity() * localGravityScale * delta * mod

func doCoyoteTime():
	if is_on_floor():
		canJump = true
		coyote_timer.stop()
	elif coyote_timer.is_stopped():
		coyote_timer.start()
	
func _on_timer_timeout():
	#Coyote timer
	canJump = false
	pass # Replace with function body.

func jumpBuffer(delta: float):
	# Handle jump.
	if Input.is_action_just_pressed("jump_" + str(player_num)):
		jumpTimeRemaining = jumpBufferTime

	if jumpTimeRemaining > 0:
		if canJump:
			doJump()
			jumpTimeRemaining = 0
		jumpTimeRemaining -= delta
		
func doJump():
	velocity.y = jump_velocity
	canJump = false

func move_player():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left_" + str(player_num), "move_right_" + str(player_num))
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
