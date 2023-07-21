extends Node2D
class_name PlayerWeaponHandler


# Variables
# - Objects
var bullet_container = null
var fx_container = null

# - Weaponry
onready var inventory = $Inventory
export (int) var inventory_size: int = 4
var max_weapon_num: int
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
	max_weapon_num = weapons.size()

	if Input.is_action_just_pressed("switch_weapon") and current_weapon.get_reload_progress()[2] == false:
		weapon_number += 1
		if weapon_number >= max_weapon_num:
			weapon_number = 0

		set_weapon(weapon_number)


func add_weapon(weapon: PackedScene):
	if is_available() and (max_weapon_num + 1) >= inventory_size:
		remove_weapon()

	var instance = weapon.instance()
	instance.initialize(bullet_container, fx_container)
	inventory.call_deferred("add_child", instance)

	current_weapon = instance

func remove_weapon():
	var pickup: PackedScene = current_weapon.get_pickup()
	current_weapon.call_deferred("queue_free")

	GlobalSignals.emit_signal("drop_weapon", get_parent().global_position, pickup)


func is_available():
	if current_weapon.get_pickup() != null:
		return true
	else:
		return false



# Initialization
func initialize(bullet_cont, fx_cont):
	set_weapon(0)

	bullet_container = bullet_cont
	fx_container = fx_cont

	for weapon in weapons:
		weapon.initialize(bullet_container, fx_container)






