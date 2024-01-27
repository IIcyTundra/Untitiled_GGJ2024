extends Node3D

@onready var background_viewport = $BaseCam/BackgroundPassContainer/BackgroundPass
@onready var foreground_viewport = $BaseCam/ForegroundPassContainer/ForegroundPass

@onready var background_cam = $BaseCam/BackgroundPassContainer/BackgroundPass/BackgroundCam
@onready var foreground_cam = $BaseCam/ForegroundPassContainer/ForegroundPass/ForegroundCam
# Called when the node enters the scene tree for the first time.
func _ready():
	resize()

func resize():
	background_viewport.size = DisplayServer.window_get_size()
	foreground_viewport.size = DisplayServer.window_get_size()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	background_cam.global_transform = GameManager.player.cam_point.global_transform
	foreground_cam.global_transform = GameManager.player.cam_point.global_transform
