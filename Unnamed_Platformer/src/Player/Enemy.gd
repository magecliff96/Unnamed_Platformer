extends "res://src/Player/Actor.gd"


func _ready() -> void:
	set_physics_process(false) #enemy will not load movement until player is in view
	actor_velocity.x = -actor_speed.x
	
	
	
func _on_StompDetector_body_entered(body: Node) -> void:
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
	queue_free()

# hits wall, it moves the opposite way
func _physics_process(delta: float) -> void:
	actor_velocity.y += actor_gravity * delta
	if is_on_wall():
		actor_velocity.x *= -1.0 
	actor_velocity.y = move_and_slide(actor_velocity, FLOOR_NORMAL).y
	





