extends CharacterBody2D

class_name Player

@export var player_num: int = 0
@export var speed: float = 300.0
@export var jump_velocity = -400.0
@export var fallMod: float = 2 #Multiplica al caer (para que caiga mas rápido)
@export var localGravityScale: float = 6
@export var jumpBufferTime: float = 1
@export var coyoteTime: float = 0.05
@export var animated_sprite: AnimatedSprite2D
@export var action: Action
@export var actionCDTime: float
@export var attack_shape:CollisionShape2D
@export var character_texture:Texture2D
@export var animator: AnimationPlayer

@onready var body_collision_shape_2d = $Body_CollisionShape2D
@onready var coyote_timer = $CoyoteTimer

var jumpTimeRemaining: float = 0
var onCoyoteTime: bool = false
var canJump: bool = false
var doingAction: bool = false
var animateJump: bool = false
var grounded: bool = false
var actionCD: float = 0
var canMove: bool = true
var game_controller : GameController
var onFinalState : bool = false

func set_game_controller(game_control):
	game_controller = game_control
	

func _process(delta):
	doCoyoteTime()
	jumpBuffer(delta)
	checkAction(delta)
	slowJump()
	playAnims()
	checkGround()

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
		
func checkAction(delta: float):
	if onFinalState:
		return
	
	if Input.is_action_just_pressed("action_" + str(player_num)) and actionCD <= 0:
		doingAction = true
		#attack_shape.set_deferred("disabled", false)

		actionCD = actionCDTime
		action.doAction()
	
	actionCD -= delta

func slowJump():
	if Input.is_action_just_released("jump_" + str(player_num)) and velocity.y < 0:
		velocity.y /= 6

func doJump():
	canJump = false
	if canMove:
		velocity.y = jump_velocity
		animateJump = true

func move_player():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left_" + str(player_num), "move_right_" + str(player_num))
	
	#flip to direction
	if canMove:
		if direction > 0:
			#animated_sprite.flip_h = false
			body_collision_shape_2d.scale.x = abs(body_collision_shape_2d.scale.x)
		elif direction < 0:
			#animated_sprite.flip_h = true
			body_collision_shape_2d.scale.x = abs(body_collision_shape_2d.scale.x) * -1
		
	if direction and canMove:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)	

func playAnims():
	if onFinalState:
		return
	var direction := Input.get_axis("move_left_" + str(player_num), "move_right_" + str(player_num))
	
	if !doingAction:
		if !is_on_floor():
			if animateJump:
				animateJump = false
				animated_sprite.play("jump")
			else:
				animated_sprite.play("jump_peak")
		else:
			if direction and canMove:
				animated_sprite.play("run")
			else:
				animated_sprite.play("idle")

func finish_action():
	print_debug("TERMINO ACTION")
	#attack_shape.set_deferred("disabled", false)
	doingAction = false
	
func checkGround():
	if is_on_floor() and !grounded:
		#Acaba de aterrizar
		animateJump = false
	
	grounded = is_on_floor()

func togleMovement(active: bool):
	canMove = active
	
func explodeBubble():
	game_controller.pom_win_round()
	#Animar explosion burbuja
	
func playWin():
	onFinalState = true
	animated_sprite.play("win")	
	
func playDefeat():
	onFinalState = true
	animated_sprite.play("defeat")
	if animator:
		animator.play("defeat")
