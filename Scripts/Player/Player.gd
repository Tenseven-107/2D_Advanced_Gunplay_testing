extends KinematicBody2D
class_name Player



# Combat objects
onready var hitbox = $Hitbox

# Animations
onready var anims = $Legs/Leg_anims
var current_angle: int = 1 # The rotation of the legs, used for player aiming to current walking angle when quickfiring

# Movement
var speed: float = 0
export (float, 0, 1000) var max_speed: float = 95
export (float, 0, 100) var acceleration: float = 15
export (float) var speed_multiplier: int = 100
var velocity: Vector2 = Vector2.ZERO

# Misc
onready var cam_transform = $Cam_transform



# Setup
func _ready():
	pass


# Processes
func _physics_process(delta):
	movement_loop(delta)

func _process(delta):
	animation_loop()



# Movement
func movement_loop(delta):
	velocity = get_axis() * speed
	if get_axis() == Vector2.ZERO:
		velocity = Vector2.ZERO
		speed = 0
	else:
		speed += acceleration
		speed = clamp(speed, -max_speed, max_speed)

	velocity = move_and_slide(velocity * speed_multiplier * delta)

func get_axis():
	var input_vector: Vector2
	input_vector.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	input_vector.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))

	return input_vector



# Play animations
func animation_loop():
	match get_axis():
		Vector2(0, 1):
			current_angle = 1
		Vector2(1, 1):
			current_angle = 2
		Vector2(1, 0):
			current_angle = 3
		Vector2(1, -1):
			current_angle = 4
		Vector2(0, -1):
			current_angle = 5
		Vector2(-1, -1):
			current_angle = 6
		Vector2(-1, 0):
			current_angle = 7
		Vector2(-1, 1):
			current_angle = 8

	var animation: String 
	if velocity == Vector2.ZERO:
		animation = "idle-" + String(current_angle)
	else:
		animation = String(current_angle)

	anims.play(animation)



# Initialization
func initialize(camera: Camera2D, bullet_container: Node):
	cam_transform.remote_path = camera.get_path()











