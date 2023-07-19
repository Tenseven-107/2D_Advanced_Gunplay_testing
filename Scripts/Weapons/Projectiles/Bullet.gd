extends KinematicBody2D
class_name Bullet


# Objects
onready var sprite = $Sprite
onready var trail = $Trail

onready var collider = $Collider
onready var dropoff_timer = $Dropoff_timer

onready var collision_tween = $Collision_tween
onready var dropoff_tween = $Dropoff_tween

var bullet_container = null
var fx_container = null

# Stats
# - FX
export (PackedScene) var collision_effect: PackedScene
export (PackedScene) var kill_effect: PackedScene
export (int) var trail_length: int = 5
var trail_active: bool = true

# - Stats
export (int) var damage: int = 25
export (int, 2, 100) var times_ricochet: int = 4
export (int) var speed: int = 500
var velocity = Vector2.ZERO
export (float) var dropoff_time: float = 10



# Set up
func _ready():
	velocity = Vector2(speed, 0).rotated(rotation)
	dropoff_timer.wait_time = dropoff_time
	dropoff_timer.start()

	dropoff_timer.connect("timeout", self, "dropoff")

	trail_active = true



# Process
func _physics_process(delta):
	move(delta)
	generate_trail()



# Moving and colliding
func move(delta):

	# Moving
	var collision = move_and_collide(velocity * delta)

	# Ricochetting
	if collision:
		var rot: float = rotation
		var reflect = collision.remainder.bounce(collision.normal)

		times_ricochet -= 1
		velocity = velocity.bounce(collision.normal)
		move_and_collide(reflect)
		rotation = -rot

		collision_tween.interpolate_property(collider, "disabled", true, false, 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		collision_tween.start()

#		var collision_inst = collision_effect.instance()
#		collision_inst.global_position = self.global_position
#		collision_inst.global_rotation = sprite.rotation
#		fx_container.call_deferred("add_child", collision_inst)

		if collision and times_ricochet <= 0:
			queue_free()



# Hitting
func hit_body(body):
	var fx_rot = rad2deg(global_position.angle_to_point(body.global_position))
	body.handle_hit(damage, fx_rot)
	queue_free()



# Generating Trail
func generate_trail():
	if trail_active == true:
		trail.global_position = Vector2.ZERO
		trail.global_rotation = 0

		var point: Vector2 = global_position
		trail.add_point(point)

		while trail.get_point_count() > trail_length:
			trail.remove_point(0)



# Dropoff
func dropoff():
	dropoff_tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2.ZERO, 0.1, 
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	dropoff_tween.start()
	trail_active = false

	dropoff_tween.connect("tween_all_completed", self, "destroy")

func destroy():
	call_deferred("queue_free")



# Initialization
func initialize(bullet_cont, fx_cont):
	self.container = bullet_cont
	self.fx_container = fx_cont





