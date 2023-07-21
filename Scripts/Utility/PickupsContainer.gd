extends Node2D



# Setup
func _ready():
	GlobalSignals.connect("drop_weapon", self, "spawn_weapon")


# Spawn weapons
func spawn_weapon(pos: Vector2, weapon: PackedScene):
	var instance = weapon.instance()
	instance.global_position = pos

	call_deferred("add_child", instance)
