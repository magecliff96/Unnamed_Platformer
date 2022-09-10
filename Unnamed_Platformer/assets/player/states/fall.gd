extends BaseState

export (NodePath) var run_node
export (NodePath) var walk_node
export (NodePath) var idle_node
export (NodePath) var jump_node
export (NodePath) var fly_node

onready var run_state: BaseState = get_node(run_node)
onready var walk_state: BaseState = get_node(walk_node)
onready var idle_state: BaseState = get_node(idle_node)
onready var jump_state: BaseState = get_node(jump_node)
onready var fly_state: BaseState = get_node(fly_node)

var buffer_timer : float
var buffer_threshold : float = 0.1

func enter() -> void:
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	.enter()

func physics_process(delta: float) -> BaseState:
	var move = 0
	buffer_timer -= delta
	
	if Input.is_action_pressed("move_left"):
		move = -1
		player.animations.flip_h = true
	elif Input.is_action_pressed("move_right"):
		move = 1
		player.animations.flip_h = false
	
	player.velocity.x = move * player.move_speed
	player.velocity.y += player.fall_gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("jump") and player.jump_was_released:
		return fly_state
		
	if Input.is_action_just_pressed("jump"):
		buffer_timer = buffer_threshold
		
	if player.is_on_floor() || player.is_coyote_active():
		if buffer_timer >= 0.0:
			return jump_state
		if move != 0:
			if Input.is_action_pressed("run"):
				return run_state
			return walk_state
		else:
			return idle_state

	return null
