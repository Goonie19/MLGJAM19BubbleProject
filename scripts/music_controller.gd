extends AudioStreamPlayer2D

class_name MusicController

func stop_music():
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80, 1)
	tween.connect("finished", stop)
	
func stop_song():
	stop()
