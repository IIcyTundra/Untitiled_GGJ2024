extends CharacterBody3D

signal health_changed(health_value)


const SPEED = 6.0
var health = 3
const JUMP_VELOCITY = 4.5
@onready var mesh_instance_3d = $Hand/MeshInstance3D
var player_radius = 5.0
@export var mouse_sens : float = 0.001

var mouse_pos : Vector2
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var anchor_point = $AnchorPoint
@onready var backcam := $CamOrigin/SpringArm3D/BaseCam/BackgroundPassContainer/BackgroundPass/BackgroundCam
@onready var forecam := $CamOrigin/SpringArm3D/BaseCam/ForegroundPassContainer/ForegroundPass/ForegroundCam
@onready var camera := $CamOrigin/SpringArm3D/BaseCam
@onready var spring_arm_3d = $CamOrigin/SpringArm3D
	
func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN )
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("t_quit"):
		$"../".exit_game(name.to_int())
		get_tree().quit()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		anchor_point.look_at(direction + position)
		
	move_and_slide()
		
		

func receive_damage():
	health -= 1
	if health <= 0:
		health = 3
		position = Vector3.ZERO
	health_changed.emit(health)

