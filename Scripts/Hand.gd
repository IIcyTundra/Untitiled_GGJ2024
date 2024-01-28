extends CharacterBody3D

signal hit_player
signal hit_wall(push_v: Vector3)

const TURN_SPEED_MAX := 100 # in radians/sec
const TURN_SPEED_MIN := 10 # in radians/sec
const TURN_ACC := 5 # in radians/sec
const TURN_Thrash := 0.1 # in radians/sec
const PUSH_HORIZONTAL_V := 15.0
const PUSH_VERTICAL_V := 5.0
const HIT_WALL_CD := 0.2

var target_angle: float = 0.0
var ang_speed: float = 0.0
var hit_wall_timer = 0.0
var direction: Vector2
var is_clockwise = true
var can_hit_wall = true
var done = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if !can_hit_wall:
		hit_wall_timer -= delta
		if hit_wall_timer < 0:
			can_hit_wall = true

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

	


func _on_area_3d_body_entered(body):
	var push_v = Vector3.ONE * PUSH_HORIZONTAL_V
	push_v.y = PUSH_VERTICAL_V
	if body.has_method("push"):
		body.push(push_v)
	elif body.is_in_group("Wall"):
		push_v = Vector3(-sin(rotation.y), 0, -cos(rotation.y)) * PUSH_HORIZONTAL_V
		push_v.y = PUSH_VERTICAL_V
		hit_wall.emit(push_v)
		can_hit_wall = false
		hit_wall_timer = HIT_WALL_CD
		

func _on_area_3d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print(area.name)
	print(area_rid)
