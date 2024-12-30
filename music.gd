extends Node

@onready var songplayers = {} # dict with keys = song name (string), and values = AudioStreamPlayer2D
var path_to_music_dir = "res://assets/audio/music/"
var current_playing = null
var fade_duration = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_music()
	SignalBus.connect("play_random_song", play_random)
	pass # Replace with function body.

func load_music():
	var dir = DirAccess.open(path_to_music_dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".mp3") or file_name.ends_with(".wav"):
				var file_path = path_to_music_dir + file_name
				var stream = load(file_path) as AudioStream
				if stream:
					var player = AudioStreamPlayer2D.new()
					player.stream = stream
					var song_name = file_name.get_basename()
					songplayers[song_name] = player
					add_child(player) # Add the player to the scene tree
			file_name = dir.get_next()
		dir.list_dir_end()

func play(songname: String):
	var song = songplayers.get(songname)
	if song:
		if current_playing:
			current_playing.stop()
		current_playing = song
		song.play()
		song.connect("finished",_on_song_finish)

func _on_song_finish():
	current_playing = null

func play_random():
	fade_out()
	var keys = songplayers.keys()
	if keys.size() > 0:
		var random_songname = keys[randi() % keys.size()]
		play(random_songname)
	return

func fade_out():
	if current_playing:
		var tween = Tween.new()
		add_child(tween)
		tween.interpolate_property(current_playing, "volume_db", current_playing.volume_db, -80, fade_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		await tween.finished
		current_playing.stop()
		current_playing.volume_db = 0 # Reset volume for next play
		current_playing = null
		tween.queue_free()
