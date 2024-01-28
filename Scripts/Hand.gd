extends CharacterBody3D

signal hit_player
signal hit_wall(push_v: Vector3)

const TURN_SPEED_MAX := 100 # in radians/sec
const TURN_SPEED_MIN := 10 # in radians/sec
const TURN_SPEED_HOLD := 5.0
const TURN_SPEED_SWING := 15.0
const TURN_ACC := 5 # in radians/sec
const TURN_Thrash := 0.1 # in radians/sec
const PUSH_HORIZONTAL_V := 50.0
const PUSH_VERTICAL_V := 5.0
const HIT_WALL_CD := 0.2
const SWING_DURATION := 0.25

var target_angle: float = 0.0
var ang_speed: float = 0.0
var hit_wall_timer = 0.0
var swing_duration_timer = 0.0
#var direction: Vector2
var direction: float = 1.0
var is_clockwise = true
var can_hit_wall = true
var done = true
var attack_r_pressed = false
var attack_l_pressed = false

enum HAND_STATE {HODING, SWING, IDLE}
var hand_state: HAND_STATE = HAND_STATE.IDLE
enum ACTION_STATE {HOLD_CLOCKWISE, HOLD_COUNTERCLOCKWISE, IDLE}
var action_state: ACTION_STATE = ACTION_STATE.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if !can_hit_wall:
		hit_wall_timer -= delta
		if hit_wall_timer < 0:
			can_hit_wall = true

func _physics_process(delta: float):
	if hand_state == HAND_STATE.IDLE: 
		if action_state == ACTION_STATE.HOLD_CLOCKWISE or action_state == ACTION_STATE.HOLD_COUNTERCLOCKWISE:
			hand_state = HAND_STATE.HODING
		return
	
	if hand_state == HAND_STATE.HODING:
		rotation.y = rotation.y + TURN_SPEED_HOLD * delta * direction
	elif hand_state == HAND_STATE.SWING:
		swing_duration_timer -= delta
		if swing_duration_timer < 0:
			hand_state = HAND_STATE.IDLE
		else:
			rotation.y = rotation.y + TURN_SPEED_SWING * delta * direction
		
	
#func _set_target_dir(dir):
	#direction = dir
	#var old_direction_p = Vector2(-sin(rotation.y), cos(rotation.y))
	#var new_is_clockwise = direction.dot(old_direction_p) < 0
	#if new_is_clockwise != is_clockwise:
		#ang_speed = 0
	#is_clockwise = new_is_clockwise
	#done = false

func attack_right_pressed():
	attack_r_pressed = true
	if action_state == ACTION_STATE.IDLE:
		action_state = ACTION_STATE.HOLD_CLOCKWISE
		direction = 1.0
	
func attack_left_pressed():
	attack_l_pressed = true
	if action_state == ACTION_STATE.IDLE:
		action_state = ACTION_STATE.HOLD_COUNTERCLOCKWISE
		direction = -1.0

func attack_right_released():
	attack_r_pressed = false
	if attack_l_pressed == true:
		action_state = ACTION_STATE.HOLD_COUNTERCLOCKWISE
		direction = -1.0
	else:
		action_state = ACTION_STATE.IDLE
		if hand_state == HAND_STATE.HODING:
			hand_state = HAND_STATE.SWING
			swing_duration_timer = SWING_DURATION
			direction = -1.0
	
func attack_left_released():
	attack_l_pressed = false
	if attack_r_pressed == true:
		action_state = ACTION_STATE.HOLD_CLOCKWISE
		direction = 1.0
	else:
		action_state = ACTION_STATE.IDLE
		if hand_state == HAND_STATE.HODING:
			hand_state = HAND_STATE.SWING
			swing_duration_timer = SWING_DURATION
			direction = 1.0

func _on_area_3d_body_entered(body):
	var push_v = Vector3.ONE * PUSH_HORIZONTAL_V
	push_v.y = PUSH_VERTICAL_V
	if body.has_method("push"):
		print(body.name)
	elif body.is_in_group("Wall"):
		push_v = Vector3(-sin(rotation.y), 0, -cos(rotation.y)) * PUSH_HORIZONTAL_V
		push_v.y = PUSH_VERTICAL_V
		hit_wall.emit(push_v)
		can_hit_wall = false
		hit_wall_timer = HIT_WALL_CD
		

func _on_area_3d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var p = area.get_parent()
	if p.is_in_group("Hand"):
		var material = $MeshInstance3D.get_surface_override_material(0)
		material.albedo_color = Color(0, 1, 0)
		$MeshInstance3D.set_surface_override_material(0, material)

func _on_area_3d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	var p = area.get_parent()
	if p.is_in_group("Hand"):
		var material = $MeshInstance3D.get_surface_override_material(0)
		material.albedo_color = Color(1, 0, 0)
		$MeshInstance3D.set_surface_override_material(0, material)
