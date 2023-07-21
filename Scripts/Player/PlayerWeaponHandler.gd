extends Node2D
class_name PlayerWeaponHandler


# Objects
# - Weaponry
onready var inventory = $Inventory
var current_weapon = null
var weapon_number: int = 0
var weapons: Array

# - UI
onready var bullet_counter = $Bullet_couner
onready var reload_progress = $Reload_progress



# Set up
func _ready():
	set_weapon(0)


# Process
func _process(delta):
	handle_weapon()
	weapon_switching()



# Weapon handling
func handle_weapon():
	if is_instance_valid(current_weapon) and current_weapon.is_in_group("Guns"):
		bullet_counter.text = String(current_weapon.get_ammo()[0])
		reload_progress.value = current_weapon.get_reload_progress()[0]
		reload_progress.max_value = current_weapon.get_reload_progress()[1]

		if Input.is_action_pressed("fire") and current_weapon.automatic == true:
			current_weapon.fire()
		elif Input.is_action_just_pressed("fire"):
			current_weapon.fire()

		if Input.is_action_just_pressed("reload"):
			current_weapon.reload()



# Weapon switching
func set_weapon(weapon_number):
	weapons = inventory.get_children()
	current_weapon = inventory.get_child(weapon_number)


func weapon_switching():
	var max_weapon_num: int = weapons.size()

	if Input.is_action_just_pressed("switch_weapon") and current_weapon.get_reload_progress()[2] == false:
		weapon_number += 1
		if weapon_number >= max_weapon_num:
			weapon_number = 0

		set_weapon(weapon_number)






