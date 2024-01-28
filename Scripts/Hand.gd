extends CharacterBody3D

const TURN_SPEED_MAX := 100 # in radians/sec
const TURN_SPEED_MIN := 10 # in radians/sec
const TURN_ACC := 5 # in radians/sec
const TURN_Thrash := 0.1 # in radians/sec

var target_angle: float = 0.0
var ang_speed: float = 0.0
var direction: Vector2
var is_clockwise = true
var done = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta: float):
	if done:
		return
	var old_direction = Vector2(cos(rotation.y), sin(rotation.y))
	ang_speed += TURN_ACC * delta
	ang_speed = clamp(ang_speed, TURN_SPEED_MIN, TURN_SPEED_MAX)
	var diff = direction - old_direction
	var new_direction = old_direction + diff * ang_speed * delta
	rotation.y = new_direction.angle()
	if diff.length() < TURN_Thrash:
		done = true
	
func _set_target_dir(dir):
	direction = dir
	var old_direction_p = Vector2(-sin(rotation.y), cos(rotation.y))
	var new_is_clockwise = direction.dot(old_direction_p) < 0
	if new_is_clockwise != is_clockwise:
		ang_speed = 0
	is_clockwise = new_is_clockwise
	done = false

	
