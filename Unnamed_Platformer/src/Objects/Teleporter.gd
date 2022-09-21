tool
extends Area2D


#Variable to export for configuration using the Inspector
export var next_scene: PackedScene

onready var anim_player: AnimationPlayer = $AnimationPlayer

#Function to detect signal when the player enters the portal
func _on_body_entered(body: Node) -> void:
	teleport()

#Generates a warning when the portal doesn't have a connected scene
#Setting a scene then saving and reloading will usually fix it
func _get_configuration_warning() -> String:
	return "The next scene property can't be empty" if not next_scene else ""

#Plays a fade-in animation, and when the animation finishes, 
#loads the next scene
func teleport () -> void:
	anim_player.play("fade_in_start")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(next_scene)
