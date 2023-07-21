extends Area2D


# Objects
export (String) var weapon_path: String # To avoid errors, a path is used instead
onready var label = $Label

# Utility
var active: bool = false
var player: Player



# Setup
func _ready():
	active = false
	label.text = InputMap.get_action_list("interact")[0].as_text()
	label.hide()



# Activate/ deactivate
func _on_WeaponPickup_body_entered(body: Node):
	if body.is_in_group("Player"):
		active = true
		label.show()

		player = body


func _on_WeaponPickup_body_exited(body: Node):
	if body.is_in_group("Player") and body == player:
		active = false
		label.hide()



# Process
func _process(delta):
	if active == true and Input.is_action_just_pressed("interact"):
		if player.check_available() == true:
			player.equip(load(weapon_path))

			call_deferred("queue_free")













