extends Node3D
var soundplayer3D : AudioStreamPlayer3D
var sound3D : AudioStream

# Called when the node enters the scene tree for the first time.
func _set_sound(path : String):
	sound3D = load(path)
	soundplayer3D.set_stream(sound3D)
	
	var randPitch : float = randf_range(-.25,.25) + 1.0
	soundplayer3D.set_pitch_scale(randPitch)
	soundplayer3D.play()
func _ready():
	soundplayer3D = get_node("AudioStreamPlayer3D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass#if !soundplayer3D.is_playing:
		#queue_free()
	
