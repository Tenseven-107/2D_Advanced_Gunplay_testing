extends Area2D


# Objects
export (String) var weapon_path: String # To avoid errors, a path is used instead
onready var collider = $Collider
onready var label = $Label
onready var anims = $AnimationPlayer
onready var tween = $Tween

# Utility
var active: bool = false
var player: Player



# Setup
func _ready():
	active = false

	label.text = InputMap.get_action_list("interact")[0].as_text()
	label.hide()

	anims.play("Idle")
	tween.interpolate_property(self, "scale", Vector2.ZERO, Vector2(1, 1), 0.25, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()



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

			collider.disabled = true
			active = false

			tween.interpolate_property(self, "position", global_position, player.global_position, 0.25, 
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2.ZERO, 0.25,
			Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)

			tween.start()
			tween.connect("tween_all_completed", self, "queue_free")













