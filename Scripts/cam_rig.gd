extends Node3D

@onready var background_viewport = $BackgroundPassContainer/BackgroundPass
@onready var foreground_viewport = $ForegroundPassContainer/ForegroundPass

@onready var background_cam = $BackgroundPassContainer/BackgroundPass/BackgroundCam
@onready var foreground_cam = $ForegroundPassContainer/ForegroundPass/ForegroundCam
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.set_player(self)
	resize()

func resize():
	background_viewport.size = DisplayServer.window_get_size()
	foreground_viewport.size = DisplayServer.window_get_size()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	background_cam.global_transform = global_transform
	foreground_cam.global_transform = global_transform
