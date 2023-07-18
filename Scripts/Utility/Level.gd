extends Node2D


# Camera
onready var camera = $Game_camera

# Containers
onready var player_container = $Player_container
onready var bullet_container
onready var fx_container

# Objects
var player = null


# Set up
func _ready():
	randomize()

	player = player_container.get_child(0)
	player.initialize(camera, bullet_container)
