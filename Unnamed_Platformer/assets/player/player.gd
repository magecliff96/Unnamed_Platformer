class_name Player
extends KinematicBody2D

#configurable inputs to be inherited
export (float) var move_speed
export (float) var jump_height
export (float) var jump_time_to_peak 
export (float) var jump_time_to_descent 

var velocity := Vector2.ZERO

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

onready var animations = $animations
onready var states = $state_manager

var was_on_floor : bool
export var coyote_timer : float 
var coyote_threshold : float = 0.1
var jump_was_released: bool

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	states.init(self)

func _unhandled_input(event: InputEvent) -> void:
	states.input(event)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
	self.coyote_process(delta)

func _process(delta: float) -> void:
	states.process(delta)

func coyote_process(delta: float) -> void:
	coyote_timer -= delta

	if !self.is_on_floor() && self.was_on_floor:
		coyote_timer = coyote_threshold
	
	if self.velocity.y < 0:
		coyote_timer = 0
		
	if self.is_on_floor():
		self.was_on_floor = true
	else:
		self.was_on_floor = false

func is_coyote_active() -> bool:
	if self.coyote_timer > 0:
		return true
	else: 
		return false

