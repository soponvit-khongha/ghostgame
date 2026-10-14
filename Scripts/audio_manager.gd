# Autoload: เล่นเสียงประกอบ (SFX) และเพลงพื้นหลัง
extends Node

var sfx := {}
var music_player: AudioStreamPlayer
var sfx_on := true
var music_on := true

func _ready() -> void:
	for n in ["jump", "coin", "hit", "death", "shoot", "stomp", "power", "win", "gameover", "portal"]:
		sfx[n] = load("res://Assets/Sound/%s.wav" % n)
	music_player = AudioStreamPlayer.new()
	music_player.stream = load("res://Assets/Sound/music.wav")
	music_player.volume_db = -9.0
	music_player.finished.connect(func(): if music_on: music_player.play())
	add_child(music_player)

func play(n: String) -> void:
	if not sfx_on or not sfx.has(n): return
	var p := AudioStreamPlayer.new()
	p.stream = sfx[n]
	p.finished.connect(p.queue_free)
	add_child(p)
	p.play()

func play_music() -> void:
	if music_on and not music_player.playing: music_player.play()

func stop_music() -> void:
	music_player.stop()

func set_music(on: bool) -> void:
	music_on = on
	if on:
		play_music()
	else:
		stop_music()
