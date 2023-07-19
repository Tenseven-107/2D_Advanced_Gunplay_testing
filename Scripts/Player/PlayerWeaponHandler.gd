extends Node2D
class_name PlayerWeaponHandler


# Objects
onready var bullet_counter = $Bullet_couner
var current_weapon


# Set up
func _ready():
	current_weapon = get_child(0)


# Process
func _process(delta):

	if is_instance_valid(current_weapon) and current_weapon.is_in_group("Guns"):
		bullet_counter.text = String(current_weapon.get_ammo()[0])
		if Input.is_action_pressed("fire") and current_weapon.automatic == true:
			current_weapon.fire()
		elif Input.is_action_just_pressed("fire"):
			current_weapon.fire()

		if Input.is_action_just_pressed("reload"):
			current_weapon.reload()
