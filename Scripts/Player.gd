extends CharacterBody3D


const SPEED = 6.0

const JUMP_VELOCITY = 4.5

@onready var cam_point = $CamPoint
@onready var character_model = $CharacterModel#Change after model is imported
@onready var cam_rig = $CamRig
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _enter_tree():
	set_multiplayer_authority(name.to_int())
	#if(is_multiplayer_authority()):
		#print(cam_rig)		#cam_rig.process_mode = Node.PROCESS_MODE_INHERIT
func _ready():
	GameManager.set_player(self)



func _physics_process(delta):
	if is_multiplayer_authority():
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
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
