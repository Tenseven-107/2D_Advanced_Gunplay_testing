extends Node2D
class_name PlayerTorso


# Animations
onready var anims = $Torso_anims

# Objects
onready var player: Player = get_parent()



# Setup
func _ready():
	pass



# Processes
func _process(delta):
	animation_loop()



# Animations
func animation_loop():
	var animation: String

	if Input.is_action_pressed("fire") or Input.is_action_pressed("aim"):
		return
	else:
		animation = "idle-" + String(player.current_angle)

	anims.play(animation)
