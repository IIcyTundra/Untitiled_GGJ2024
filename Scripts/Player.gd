extends CharacterBody3D


const SPEED = 6.0

const JUMP_VELOCITY = 4.5
@onready var mesh_instance_3d = $Node3D/MeshInstance3D
@onready var node_3d = $Node3D
var player_radius = 5.0
var mouse_sens : float = 0.001
@onready var cam_point = $CamPoint
@onready var character_model = $CharacterModel#Change after model is imported
#@onready var cam_rig = $CamRig
var mouse_pos : Vector2
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera := $CamOrigin/SpringArm3D/BaseCam
@onready var backcam := $CamOrigin/SpringArm3D/BaseCam/BackgroundPassContainer/BackgroundPass/BackgroundCam
@onready var forecam := $CamOrigin/SpringArm3D/BaseCam/ForegroundPassContainer/ForegroundPass/ForegroundCam
func _enter_tree():
	set_multiplayer_authority(name.to_int())
	#if(is_multiplayer_authority()):
		#print(cam_rig)		#cam_rig.process_mode = Node.PROCESS_MODE_INHERIT
func _ready():
	GameManager.set_player(self)
	camera.current = is_multiplayer_authority()
	backcam.current = is_multiplayer_authority()
	forecam.current = is_multiplayer_authority()
	print(camera)
	
func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		#var mousePos = event.position;
		#var rayOrigin = camera.project_ray_origin(mousePos)
		#var rayNormal = camera.project_ray_normal(mousePos)
		#print("------")
		#print(position)
		#print(rayOrigin)
		#print(rayNormal)
		#var v = position - rayOrigin
		#print(v.normalized())
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if is_multiplayer_authority():
			if event is InputEventMouseMotion:
					node_3d.rotation.x -= event.relative.y * mouse_sens
					node_3d.rotation.x = clamp(node_3d.rotation.x,deg_to_rad(-40), deg_to_rad(40))
					node_3d.rotation.y -= event.relative.x * mouse_sens
					#mesh_instance_3d.translate_object_local(Vector3(event.relative.x, 0, event.relative.y)) 
func _physics_process(delta):
	if is_multiplayer_authority():
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

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
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
		#character_model.look_at(direction + position)  Isn't needed currently

		move_and_slide()


#func _process(delta):
	#if camera != null:
		#mouse_pos = get_viewport().get_mouse_motion()
		#print(mouse_pos)
		
		
