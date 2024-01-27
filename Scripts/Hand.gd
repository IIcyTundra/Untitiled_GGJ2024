extends CharacterBody3D

const acc = 5.0
const max_speed = 4.5
@onready var map = "res://Scenes/test_map.tscn"
@onready var background_cam = $BaseCam/BackgroundPassContainer/BackgroundPass/BackgroundCam
@onready var foreground_cam = $BaseCam/ForegroundPassContainer/ForegroundPass/ForegroundCam

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide()
	
#func _rotat_to(event, m_position):
	#var spaceState = get_world_3d().direct_space_state
	##position.angle_to(transform.basis)
	#var mousePos = event.position
	#var camera = get_viewport().get_camera_3d()
	#var rayOrigin = camera.project_ray_origin(mousePos)
	#var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 2000
	#var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd, 0b0010)
	#var rayArray = spaceState.intersect_ray(query)
	#print("--------")
	##if rayArray.has("position"):
		##print(rayArray["position"])
	#if foreground_cam:
		#print(foreground_cam.position)
	#print(rayOrigin)
	#print(m_position)
	#print(rayEnd)
	#print(camera.project_ray_normal(mousePos))
	
