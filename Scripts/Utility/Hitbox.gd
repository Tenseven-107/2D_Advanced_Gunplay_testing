extends Area2D
class_name Entity


# Objects
onready var parent = get_parent()

# Stats
export (bool) var godmode: bool = false
export (bool) var invincible: bool = false
export (float) var i_frames: float = 0.25
var i_frame_timer: Timer = null

export (int) var max_hp: int = 100
var hp: int = 100
export (int) var team: int = 0 # Decides which team the entity is on, 
							# if a damager is on the same team, damage will not be dealt. Else the damage will be applied.
							# 0: Player team, 1: Enemy team

# Utility
export (bool) var emit_global_signal: bool = false
export (String) var signal_name: String

# Juice
# - Animations
export (NodePath) var animplayer_path: NodePath
var animator: AnimationPlayer = null
export (String) var damage_animation: String
export (String) var heal_animation: String

# - Camera shake
export (bool) var camera_shake: bool = true
export (int) var new_cam_shake: int = 150
export (int) var cam_shake_limit: int = 1000
export (float) var cam_shake_time: float = 0.05

# - Camera zoom
export (bool) var zoom: bool = true
export (int) var new_cam_zoom: int = 1
export (int) var cam_zoom_limit: int = 1
export (float) var cam_zoom_time: float = 0.07

# - Hitstop
export (bool) var hitstop: bool = true
export (float) var hitstop_time: float = 0.07



# Set  up
func _ready():
	if animplayer_path != "":
		animator = get_node(animplayer_path)
	add_timer()

	connect("body_entered", self, "hit_detect")


# Add a timer for I-frames
func add_timer():
	var new_timer = Timer.new()

	new_timer.one_shot = true
	new_timer.wait_time = hitstop_time
	i_frame_timer = new_timer
	add_child(new_timer)



# Detect if hit
func hit_detect(body: Node):
	if body.has_method("hit_body"):
		body.hit_body(self)
	elif body.has_method("heal_body"):
		body.heal_body(self)


# Handle damage
func handle_hit(damage, damager_team, fx_rot):
	if damager_team != team and i_frame_timer.is_stopped() and invincible == false:
		if godmode == false:
			hp -= damage
			i_frame_timer.start()

		if hp <= 0:
			if emit_global_signal == true:
				pass # GlobalSignals.emit_signal(signal_name)

			parent.call_deferred("queue_free")

		if is_instance_valid(animator): 
			animator.stop()
			animator.play(damage_animation)
		if camera_shake: GlobalSignals.emit_signal("camera_shake", new_cam_shake, cam_shake_time, cam_shake_limit)
		if zoom: GlobalSignals.emit_signal("camera_zoom", new_cam_zoom, cam_zoom_time, cam_zoom_limit)
		if hitstop: GlobalSignals.emit_signal("hitstop", hitstop_time)


func get_team():
	return team



# Heal
func heal(healed_hp):
	hp += healed_hp
	hp = clamp(hp, 0, max_hp)

	if is_instance_valid(animator): animator.play(heal_animation)





