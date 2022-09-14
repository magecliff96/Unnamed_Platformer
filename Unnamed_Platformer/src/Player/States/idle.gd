extends BaseState

#setting up states using external ui
export (NodePath) var jump_node
export (NodePath) var fall_node
export (NodePath) var walk_node
export (NodePath) var run_node
export (NodePath) var dash_node
export (NodePath) var fly_node

#setting up variable names for states
onready var jump_state: BaseState = get_node(jump_node)
onready var fall_state: BaseState = get_node(fall_node)
onready var walk_state: BaseState = get_node(walk_node)
onready var run_state: BaseState = get_node(run_node)
onready var dash_state: BaseState = get_node(dash_node)
onready var fly_state: BaseState = get_node(fly_node)

func enter() -> void:
	.enter()
	player.velocity.x = 0

#entering different states based on buttons pressed
func input(event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		if Input.is_action_pressed("run"):
			return run_state
		return walk_state
	elif Input.is_action_just_pressed("jump"):
		return jump_state
	elif Input.is_action_just_pressed("dash"):
		return dash_state
	return null

#updating physics and movements
func physics_process(delta: float) -> BaseState:     
	player.velocity.y += player.fall_gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if !player.is_on_floor() && !player.is_coyote_active():
		return fall_state
	return null
