class_name MoveState
extends BaseState

export (NodePath) var jump_node
export (NodePath) var fall_node
export (NodePath) var dash_node
export (NodePath) var idle_node
export (NodePath) var walk_node
export (NodePath) var run_node

onready var jump_state: BaseState = get_node(jump_node)
onready var fall_state: BaseState = get_node(fall_node)
onready var idle_state: BaseState = get_node(idle_node)
onready var dash_state: BaseState = get_node(dash_node)
onready var walk_state: BaseState = get_node(walk_node)
onready var run_state: BaseState = get_node(run_node)

func input(event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("jump"):
		return jump_state
	
	if Input.is_action_just_pressed("dash"):
		return dash_state

	return null

func physics_process(delta: float) -> BaseState:
	if !player.is_on_floor() && !player.is_coyote_active():
		return fall_state

	var move = get_movement_input()
	if move < 0:
		player.animations.flip_h = true
	elif move > 0:
		player.animations.flip_h = false
	
	if !player.is_coyote_active(): player.velocity.y += player.fall_gravity * delta
	player.velocity.x = move * player.move_speed
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if move == 0:
		return idle_state

	return null

func get_movement_input() -> int:
	
	var move = Input.get_axis("move_left", "move_right")
	if move > 0:
		return 1
	elif move < 0:
		return -1
	
	#if Input.is_action_pressed("move_left"):
	#	return -1
	#elif Input.is_action_pressed("move_right"):
	#	return 1
	
	return 0
