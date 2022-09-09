extends BaseState

export (NodePath) var fall_node
export (NodePath) var run_node
export (NodePath) var walk_node
export (NodePath) var idle_node
export (NodePath) var fly_node

onready var fall_state: BaseState = get_node(fall_node)
onready var run_state: BaseState = get_node(run_node)
onready var walk_state: BaseState = get_node(walk_node)
onready var idle_state: BaseState = get_node(idle_node)
onready var fly_state: BaseState = get_node(fly_node)

var time : float
var jump_time : float = 0.1 #active time with which jump can be held
var jump_factor : float = 0.33

func enter() -> void:
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	.enter()
	time = 0
	player.jump_was_released = false
	player.velocity.y += player.jump_velocity * jump_factor

func physics_process(delta: float) -> BaseState:
	time += delta
	if Input.is_action_pressed("jump") and time < jump_time: 
		player.velocity.y += player.jump_velocity * (1-jump_factor) / jump_time * delta

	if Input.is_action_just_released("jump"):
		player.jump_was_released = true
			
	var move = 0
	if Input.is_action_pressed("move_left"):
		move = -1
		player.animations.flip_h = true
	elif Input.is_action_pressed("move_right"):
		move = 1
		player.animations.flip_h = false
	
	player.velocity.x = move * player.move_speed
	player.velocity.y += player.jump_gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("jump") and player.jump_was_released:
		return fly_state
	
	if player.velocity.y > 0: #remember... positive is down down down
		return fall_state
	
	if player.is_on_floor():
		if move != 0:
			if Input.is_action_pressed("run"):
				return run_state
			return walk_state
		return idle_state
	
	return null
		
