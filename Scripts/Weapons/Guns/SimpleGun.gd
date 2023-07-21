extends Node2D
class_name SimpleGun


# Stats
# - Misc
export (int) var team: int = 0

# - Projectiles
export (PackedScene) var projectile: PackedScene
export (int) var bullets: int = 1

# - Spread
export (float) var max_spread: float = 7.5
export (float) var spread_increase: float = 0.5
export (float) var spread_decrease: float = 0.05
var current_spread: float = 0

# - Ammo
var chambered_ammo: int = 0
export (int) var ammo: int = 30
export (int) var used_ammo: int = 1
var current_ammo: int = 0
export (bool) var closed_bolt: bool = true
export (float) var reload_speed: int = 1.25
export (float) var full_reload_speed: int = 4
onready var reload_timer: Timer = $Reload_timer

# - Weapon heat
export (bool) var heat: bool = false
export (float) var max_heat: float = 10
export (float) var heat_increase: float = 0.5
export (float) var heat_decrease: float = 0.1
export (float) var heat_cooldown: float = 0.5
var current_heat: float = 0
onready var heat_timer: Timer = $Heat_timer

# - Fire stats
export (bool) var automatic: bool = true
export (float) var firerate_cooldown: float = 0.1
onready var firerate_timer: Timer = $Firerate_timer

# - Objects
onready var muzzle = $Muzzle
var bullet_container = null
var fx_container = null

# Juice
# - Camera shake
export (bool) var camera_shake: bool = true
export (int) var new_cam_shake: int = 50
export (int) var cam_shake_limit: int = 500
export (float) var cam_shake_time: float = 0.05

# - Camera zoom
export (bool) var zoom: bool = false
export (int) var new_cam_zoom: int = 1
export (int) var cam_zoom_limit: int = 1
export (float) var cam_zoom_time: float = 0.07

# - Hitstop
export (bool) var hitstop: bool = false
export (float) var hitstop_time: float = 0.07



# Setup
func _ready():
	reload_timer.wait_time = reload_speed
	heat_timer.wait_time = heat_cooldown
	firerate_timer.wait_time = firerate_cooldown

	current_ammo = ammo
	if closed_bolt == true:
		chambered_ammo = used_ammo

	reload_timer.connect("timeout", self, "finish_reload")



# Process
func _process(delta):
	if heat == true and current_heat > 0:
		current_heat -= heat_decrease

	if current_spread > 0:
		current_spread -= spread_decrease


# Firing weapon
func fire():
	if (firerate_timer.is_stopped() and reload_timer.is_stopped() and heat_timer.is_stopped() 
	and current_ammo > 0 and !(current_heat >= max_heat)):

		# - Manage ammo
		if closed_bolt == true: 
			chambered_ammo = 0
		current_ammo -= used_ammo

		# - Manage heat
		if heat == true:
			current_heat += heat_increase
			if current_heat >= max_heat:
				heat_timer.start()

		# - Manage spread
		current_spread += spread_increase
		current_spread = clamp(current_spread, 0, max_spread)

		# - Fire weapon
		firerate_timer.start()
		for bullet in bullets:
			var firing_spread: float = rand_range(-current_spread, current_spread)
			muzzle.rotation_degrees = 0
			muzzle.rotation_degrees += firing_spread

			var fired_projectile: Bullet = projectile.instance()
			fired_projectile.global_position = muzzle.global_position
			fired_projectile.global_rotation = muzzle.global_rotation
			fired_projectile.initialize(bullet_container, team, fx_container)

			bullet_container.call_deferred("add_child", fired_projectile)

		if camera_shake: GlobalSignals.emit_signal("camera_shake", new_cam_shake, cam_shake_time, cam_shake_limit)
		if zoom: GlobalSignals.emit_signal("camera_zoom", new_cam_zoom, cam_zoom_time, cam_zoom_limit)
		if hitstop: GlobalSignals.emit_signal("hitstop", hitstop_time)



# Reloading
func reload():
	if current_ammo >= used_ammo:
		reload_timer.wait_time = reload_speed
		if closed_bolt == true:
			chambered_ammo += used_ammo
	else:
		reload_timer.wait_time = full_reload_speed

	current_ammo = chambered_ammo
	reload_timer.start()

func finish_reload():
	current_ammo = ammo + chambered_ammo

func get_ammo():
	var ammo_stats: Array = [current_ammo, ammo]
	return ammo_stats



# Initialization
func initialize(bullet_cont, fx_cont):
	self.bullet_container = bullet_cont
	self.fx_container = fx_cont








