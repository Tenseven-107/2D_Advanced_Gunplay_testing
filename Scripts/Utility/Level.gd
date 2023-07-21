extends Node2D


# Camera
onready var camera = $GameCamera

# Containers
onready var player_container = $Player_container
onready var bullet_container = $Bullet_container
onready var fx_container

# Objects
var player = null


# Set up
func _ready():
	randomize()

	player = player_container.get_child(0)
	player.initialize(camera, bullet_container)

	var weapons: Array = get_tree().get_nodes_in_group("Guns")
	for weapon in weapons:
		weapon.initialize(bullet_container, fx_container)
