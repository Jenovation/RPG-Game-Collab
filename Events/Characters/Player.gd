extends KinematicBody2D

# Variables (Player Movement)

var PLAYER1_VELOCITY = Vector2.ZERO
var PLAYER1_ACCELERATION = 1500
var PLAYER1_MAX_SPEED = 150
var PLAYER1_ROLL_SPEED = 250
var PLAYER1_ATTACK_SPEED = 20
var PLAYER1_SLOWDOWN = 1200

# PLAYER1_ACCELERATION = 1500    PLAYER1_MAX_SPEED = 200    PLAYER1_SLOWDOWN = 2000

enum {
	MOVE,
	ROLL,
	ATTACK,
	INTERACT
}

var state = MOVE
var ACTION_VECTOR = Vector2.DOWN

onready var PLAYER1_ANIMATION = $AnimationPlayer
onready var PLAYER1_ANIMATION_TREE = $AnimationTree
onready var PLAYER1_ANIMATION_STATE = PLAYER1_ANIMATION_TREE.get("parameters/playback")


#Functions

func _ready():
	PLAYER1_ANIMATION_TREE.active = true

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		
		ROLL:
			roll_state(delta)
		
		ATTACK:
			attack_state(delta)
		
		INTERACT:
			interact_state()

# only emits when the node detects an unhandled inputs
# checks if the player presses right-click button
func _unhandled_input(event):
	# when the player clicks RMB run interact_state() function
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
		interact_state()
	

#check if the Player is pressing directional keys
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	#check if Player is moving or not moving
	
	if input_vector != Vector2.ZERO:
		ACTION_VECTOR = input_vector
		PLAYER1_ANIMATION_TREE.set("parameters/Idle/blend_position", input_vector)
		PLAYER1_ANIMATION_TREE.set("parameters/Move/blend_position", input_vector)
		PLAYER1_ANIMATION_TREE.set("parameters/Attack/blend_position", input_vector)
		PLAYER1_ANIMATION_TREE.set("parameters/Roll/blend_position", input_vector)
		PLAYER1_ANIMATION_STATE.travel("Move")
		PLAYER1_VELOCITY = PLAYER1_VELOCITY.move_toward(input_vector * PLAYER1_MAX_SPEED, PLAYER1_ACCELERATION * delta)
	else:
		PLAYER1_ANIMATION_STATE.travel("Idle")
		PLAYER1_VELOCITY  = PLAYER1_VELOCITY.move_toward(Vector2.ZERO, PLAYER1_SLOWDOWN * delta)
	
	move ()
	
	
	#check if the Player is pressing anything while moving
	
	if Input.is_action_just_pressed("ui_select"):
		state = ROLL
	
	if Input.is_action_just_pressed("ui_accept"):
		state = ATTACK
	
	
func roll_state(delta):
	PLAYER1_VELOCITY = ACTION_VECTOR * PLAYER1_ROLL_SPEED
	PLAYER1_ANIMATION_STATE.travel("Roll")
	move ()
	
func attack_state(delta):
	PLAYER1_ANIMATION_STATE.travel("Attack")
	move ()
func interact_state():
	pass
func move():
	PLAYER1_VELOCITY = move_and_slide(PLAYER1_VELOCITY)
	
func roll_animation_finished():
	state = MOVE
	
func attack_animation_finished():
	state = MOVE
	
