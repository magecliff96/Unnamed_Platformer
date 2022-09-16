extends "res://src/Player/Actor.gd"


func _ready() -> void:
	actor_velocity.x = -actor_speed.x

# hits wall, it moves the opposite way
func _physics_process(delta: float) -> void:
	actor_velocity.y += actor_gravity * delta
	if is_on_wall():
		actor_velocity.x *= -1.0 
	actor_velocity.y = move_and_slide(actor_velocity, FLOOR_NORMAL).y
