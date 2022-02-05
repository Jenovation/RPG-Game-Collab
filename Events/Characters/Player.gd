extends KinematicBody2D

# VARIABLES (Player Movement)
var PLAYER1_VELOCITY = Vector2.ZERO
var PLAYER1_ACCELERATION = 1500
var PLAYER1_MAX_SPEED = 125
var PLAYER1_SPRINT_SPEED = 220
var PLAYER1_ROLL_SPEED = 180
var PLAYER1_SPRINT_ROLL_SPEED = 255
var PLAYER1_JUMP_FORCE = 180
var PLAYER1_SPRINT_JUMP_FORCE = 280
var PLAYER1_SUPER_JUMP_FORCE = 420
var PLAYER1_GRAVITY = 0
var PLAYER1_ATTACK_SPEED = 100
var PLAYER1_SPRINT_ATTACK_SPEED = 180
var PLAYER1_SLOWDOWN = 1000
var PLAYER1_SPRINT_SLOWDOWN = 400
# PLAYER1_ACCELERATION = 1500    PLAYER1_MAX_SPEED = 100-200    PLAYER1_SLOWDOWN = 1500-2000 Range     PLAYER1_RUN_SLOWDOWN 300-500 Range

enum {
	MOVE,
	ROLL,
	SPRINT_ROLL,
	ATTACK,
	SPRINT_ATTACK,
	JUMP,
	SPRINT_JUMP,
	SUPER_JUMP,
	SPRINT,
	SLIDE

}

var state = MOVE
var ACTION_VECTOR = Vector2.DOWN

onready var PLAYER1_ANIMATION = $AnimationPlayer
onready var PLAYER1_ANIMATION_TREE = $AnimationTree
onready var PLAYER1_ANIMATION_STATE = PLAYER1_ANIMATION_TREE.get("parameters/playback")


#FUNCTIONS
func _ready():
	PLAYER1_ANIMATION_TREE.active = true

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		
		ROLL:
			roll_state(delta)
		
		SPRINT_ROLL:
			sprint_roll_state(delta)
		
		ATTACK:
			attack_state(delta)
		
		SPRINT_ATTACK:
			sprint_attack_state(delta)
		
		JUMP:
			jump_state(delta)
		
		SPRINT_JUMP:
			sprint_jump_state(delta)
		
		SUPER_JUMP:
			super_jump_state(delta)
		
		SPRINT:
			sprint_state(delta)
		
		SLIDE:
			slide_state(delta)
	
	
	#set gravity (no functionality yet)
	PLAYER1_VELOCITY.y += PLAYER1_GRAVITY * delta
	
	
	# some main function for moving the player
func move():
	PLAYER1_VELOCITY = move_and_slide(PLAYER1_VELOCITY)
	
	
# MOVING
func move_state(delta):
	
	# controlling the direction of movement, delete this part to make animation not controllable and in a singular direction
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	#check if Player is moving or not moving
	if input_vector != Vector2.ZERO:
		ACTION_VECTOR = input_vector
		PLAYER1_ANIMATION_TREE.set("parameters/Idle/blend_position", input_vector)
		PLAYER1_ANIMATION_TREE.set("parameters/Move/blend_position", input_vector)
		PLAYER1_ANIMATION_TREE.set("parameters/Roll/blend_position", input_vector)
		PLAYER1_ANIMATION_TREE.set("parameters/Attack/blend_position", input_vector)
		PLAYER1_ANIMATION_TREE.set("parameters/Jump/blend_position", input_vector)
		PLAYER1_ANIMATION_TREE.set("parameters/Sprint/blend_position", input_vector)
		PLAYER1_ANIMATION_TREE.set("parameters/Slide/blend_position", input_vector)
		PLAYER1_ANIMATION_STATE.travel("Move")
		PLAYER1_VELOCITY = PLAYER1_VELOCITY.move_toward(input_vector * PLAYER1_MAX_SPEED, PLAYER1_ACCELERATION * delta)
	else:
		PLAYER1_ANIMATION_STATE.travel("Idle")
		PLAYER1_VELOCITY  = PLAYER1_VELOCITY.move_toward(Vector2.ZERO, PLAYER1_SLOWDOWN * delta)
	move ()
	
	#check if the Player is pressing anything while moving and enable ROLL, ATTACK, JUMP or SPRINT state
	if Input.is_action_just_pressed("ui_roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("ui_cancel"):
		state = ATTACK
	
	if Input.is_action_just_pressed("ui_jump"):
		state = JUMP
	
	if Input.is_action_pressed("ui_r3") and input_vector != Vector2.ZERO:
		state = SPRINT
	
	if Input.is_action_pressed("ui_l3") :
		state = SPRINT
	
	
#SPRINTING
func sprint_state(delta):
	
	# controlling the direction of movement, delete this part to make animation not controllable and in a singular direction
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	# probably making the character move
	if input_vector != Vector2.ZERO:
		ACTION_VECTOR = input_vector
		PLAYER1_ANIMATION_TREE.set("parameters/Idle/blend_position", input_vector)
		PLAYER1_ANIMATION_TREE.set("parameters/Move/blend_position", input_vector)
		PLAYER1_ANIMATION_TREE.set("parameters/Roll/blend_position", input_vector)
		PLAYER1_ANIMATION_TREE.set("parameters/Attack/blend_position", input_vector)
		PLAYER1_ANIMATION_TREE.set("parameters/Jump/blend_position", input_vector)
		PLAYER1_ANIMATION_TREE.set("parameters/Sprint/blend_position", input_vector)
		PLAYER1_ANIMATION_TREE.set("parameters/Slide/blend_position", input_vector)
		PLAYER1_ANIMATION_STATE.travel("Sprint")
		PLAYER1_VELOCITY = PLAYER1_VELOCITY.move_toward(input_vector * PLAYER1_SPRINT_SPEED, PLAYER1_ACCELERATION * delta)
	else:
		PLAYER1_ANIMATION_STATE.travel("Slide")
		PLAYER1_VELOCITY  = PLAYER1_VELOCITY.move_toward(Vector2.ZERO, PLAYER1_SPRINT_SLOWDOWN * delta)
	move ()
	
	
	#check if the Player is pressing anything while sprinting and enable ROLL, ATTACK or MOVE state
	if Input.is_action_just_pressed("ui_roll"):
		state = SPRINT_ROLL
	
	if Input.is_action_just_pressed("ui_cancel"):
		state = SPRINT_ATTACK
	
	if Input.is_action_just_pressed("ui_jump"):
		state = SPRINT_JUMP
	
	if Input.is_action_just_released("ui_r3"):
		state = SLIDE
	
	if Input.is_action_just_released("ui_l3"):
		state = SLIDE
	
	
#SLIDING
func slide_state(delta):
	# controlling the direction of movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	
		# making the character move
	PLAYER1_ANIMATION_STATE.travel("Slide")
	PLAYER1_VELOCITY  = PLAYER1_VELOCITY.move_toward(Vector2.ZERO, PLAYER1_SPRINT_SLOWDOWN * delta)
	move ()
	
	
#ROLLING
func roll_state(delta):
	# controlling the direction of movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	# making the character move
	PLAYER1_ANIMATION_STATE.travel("Roll")
	PLAYER1_VELOCITY = PLAYER1_VELOCITY.move_toward(input_vector * PLAYER1_ROLL_SPEED, PLAYER1_ACCELERATION * delta)
	move ()
	
	#check if Player is pressing anything while rolling and enable JUMP state on release
	if Input.is_action_just_pressed("ui_jump"):
		state = JUMP
	
	
	
#SPRINT ROLLING
func sprint_roll_state(delta):
	# controlling the direction of movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	# making the character move
	PLAYER1_ANIMATION_STATE.travel("Roll")
	PLAYER1_VELOCITY = PLAYER1_VELOCITY.move_toward(input_vector * PLAYER1_SPRINT_ROLL_SPEED, PLAYER1_ACCELERATION * delta)
	move ()
	
	#check if Player is pressing anything while rolling and enable JUMP state on release
	if Input.is_action_just_pressed("ui_jump"):
		state = SUPER_JUMP
	
	
#ATTACKING
func attack_state(delta):
	# controlling the direction of movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	# making the character move

	PLAYER1_ANIMATION_STATE.travel("Attack")
	PLAYER1_VELOCITY = PLAYER1_VELOCITY.move_toward(input_vector * PLAYER1_ATTACK_SPEED, PLAYER1_ACCELERATION * delta)
	move ()
	
#SPRINT ATTACKING
func sprint_attack_state(delta):
	# controlling the direction of movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	# making the character move

	PLAYER1_ANIMATION_STATE.travel("Attack")
	PLAYER1_VELOCITY = PLAYER1_VELOCITY.move_toward(input_vector * PLAYER1_SPRINT_ATTACK_SPEED, PLAYER1_ACCELERATION * delta)
	move ()
	
	
	
#JUMPING
func jump_state(delta):
	# controlling the direction of movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	# making the character move
	PLAYER1_ANIMATION_STATE.travel("Jump")
	PLAYER1_VELOCITY = PLAYER1_VELOCITY.move_toward(input_vector * PLAYER1_JUMP_FORCE, PLAYER1_ACCELERATION * delta)
	move ()
	
#SPRINT JUMPING
func sprint_jump_state(delta):
	# controlling the direction of movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	# making the character move
	PLAYER1_ANIMATION_STATE.travel("Jump")
	PLAYER1_VELOCITY = PLAYER1_VELOCITY.move_toward(input_vector * PLAYER1_SPRINT_JUMP_FORCE, PLAYER1_ACCELERATION * delta)
	move ()
	
	
#SUPER JUMPING
func super_jump_state(delta):
	# controlling the direction of movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	# making the character move
	PLAYER1_ANIMATION_STATE.travel("Jump")
	PLAYER1_VELOCITY = PLAYER1_VELOCITY.move_toward(input_vector * PLAYER1_SUPER_JUMP_FORCE, PLAYER1_ACCELERATION * delta)
	move ()
	
	
	#ALLOW STATE CHANGE MID ANIMATION
func jump_animation_allowchange():
	#check if Player is pressing anything while jumping and enable ROLL or ATTACK state
	if Input.is_action_pressed("ui_roll"):
		state = SPRINT_ROLL
	
	if Input.is_action_pressed("ui_cancel"):
		state = SPRINT_ATTACK

	
#END OF ANIMATION STATES
# re-enable the MOVE state after the animation or other state  has finished
func roll_animation_finished():
	state = MOVE
	
func attack_animation_finished():
	state = MOVE
	
func jump_animation_finished():
	state = MOVE
	
func sprint_animation_finished():
	state = SLIDE
	
func slide_animation_finished():
	state = MOVE
