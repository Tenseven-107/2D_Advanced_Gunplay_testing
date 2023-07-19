extends Area2D


# Objects
onready var parent = get_parent()

# Stats
export (int) var max_hp: int = 100
var hp: int = 100

# Utility
export (bool) var emit_signal: bool = false
export (String) var signal_name: String



# Set  up
func _ready():
	connect("body_entered", self, "hit_detect")



# Detect if hit
func hit_detect(body: Node):
	if body.has_method("hit_body"):
		body.hit_body(self)
	elif body.has_method("heal_body"):
		body.heal_body(self)


# Handle damage
func handle_hit(damage, fx_rot):
	hp -= damage
	if hp <= 0:
		if emit_signal == true:
			pass # GlobalSignals.emit_signal(signal_name)

		parent.call_deferred("queue_free")
