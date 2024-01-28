extends CharacterBody3D

signal health_changed(health_value)


const SPEED = 6.0
var health = 3
const JUMP_VELOCITY = 4.5
@onready var mesh_instance_3d = $Hand/MeshInstance3D
var player_radius = 5.0
@export var player_id : int = 1
@export var mouse_sens : float = 0.001
@onready var character_model = $CharacterModel#Change after model is imported

@onready var spring_arm_3d = $CamOrigin/SpringArm3D
var mouse_pos : Vector2
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var backcam := $CamOrigin/SpringArm3D/BaseCam/BackgroundPassContainer/BackgroundPass/BackgroundCam
@onready var forecam := $CamOrigin/SpringArm3D/BaseCam/ForegroundPassContainer/ForegroundPass/ForegroundCam

@onready var camera := $CamOrigin/SpringArm3D/BaseCam
@onready var hand := $Hand
@onready var collision_shape_3d = $CollisionShape3D
<<<<<<< HEAD

#func _enter_tree():
	#set_multiplayer_authority(str(name).to_int())
	#
#func _ready():
	#if not is_multiplayer_authority(): return
	#GameManager.set_player(self)
	#camera.current = is_multiplayer_authority()
	#backcam.current = is_multiplayer_authority()
	#forecam.current = is_multiplayer_authority()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack_r_%s" %[player_id]):
		hand.attack_right_pressed()
	if event.is_action_pressed("attack_l_%s" %[player_id]):
		hand.attack_left_pressed()
	
	if event.is_action_released("attack_r_%s" %[player_id]):
		hand.attack_right_released()
	if event.is_action_released("attack_l_%s" %[player_id]):
		hand.attack_left_released()
	#if event is InputEventMouseButton:
		#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN )
	#elif event.is_action_pressed("ui_cancel"):
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#if event is InputEventMouseMotion:
		#if is_multiplayer_authority():
			#var mousePos = event.position;
			#var rayOrigin = camera.project_ray_origin(mousePos)
			#var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 2000
			#var p = Plane(0, 1 , 0, position.y)
			#var point = p.intersects_ray(rayOrigin, rayEnd)
			#var direction = Vector2(point.z - position.z, point.x - position.x)
=======
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN )
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion:
			var mousePos = event.position;
			var rayOrigin = camera.project_ray_origin(mousePos)
			var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 2000
			var p = Plane(0, 1 , 0, position.y)
			var point = p.intersects_ray(rayOrigin, rayEnd)
			var direction = Vector2(point.z - position.z, point.x - position.x)
>>>>>>> 682d343efd8e2e6b984a9b518c59ed3f93192ebc
			#hand._set_target_dir(direction.normalized())

func _physics_process(delta):
	#if is_multiplayer_authority():
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		# Handle jump.
		if Input.is_action_just_pressed("jump_%s" %[player_id]) and is_on_floor():
			velocity.y = JUMP_VELOCITY
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("left_%s" %[player_id], "right_%s" %[player_id],
		 								"up_%s" %[player_id], "down_%s" %[player_id])
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		#else:
		move_and_slide()
		
	

func receive_damage():
	health -= 1
	if health <= 0:
		health = 3
		position = Vector3.ZERO
	health_changed.emit(health)
	
func push(v: Vector3):
	velocity += v
	
func hit_by_hand():
	print("hit_by_hand")

func _on_hand_hit_wall(push_v):
	push(push_v)
