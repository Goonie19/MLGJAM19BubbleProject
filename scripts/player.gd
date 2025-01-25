extends CharacterBody2D

@export var player_num: int = 0
@export var speed: float = 300.0
@export var jump_velocity = -400.0
@export var fallMod: float = 2 #Multiplica al caer (para que caiga mas rápido)
@export var localGravityScale: float = 6
@export var jumpBufferTime: float = 1
@export var coyoteTime: float = 0.05
@export var animated_sprite: AnimatedSprite2D

@onready var body_collision_shape_2d = $Body_CollisionShape2D
@onready var coyote_timer = $CoyoteTimer

var jumpTimeRemaining: float = 0
var onCoyoteTime: bool = false
var canJump: bool = false

func _process(delta):
	doCoyoteTime()
	jumpBuffer(delta)
	if Input.is_action_just_released("jump_" + str(player_num)) and velocity.y < 0:
		velocity.y /= 6
	
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
	
	#flip to direction
	if direction > 0:
		#animated_sprite.flip_h = false
		body_collision_shape_2d.scale.x = abs(body_collision_shape_2d.scale.x)
	elif direction < 0:
		#animated_sprite.flip_h = true
		body_collision_shape_2d.scale.x = abs(body_collision_shape_2d.scale.x) * -1
		
	if direction:
		velocity.x = direction * speed
		animated_sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)	
		animated_sprite.play("idle")
