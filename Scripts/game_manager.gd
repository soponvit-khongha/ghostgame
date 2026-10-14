# Autoload: เก็บคะแนน พลังชีวิต ด่านปัจจุบัน และสลับฉาก
extends Node

const MAX_HP := 30
const TOTAL_LEVELS := 4
var score := 0
var hp := MAX_HP
var level := 1
var level_start_score := 0

func new_game() -> void:
	score = 0; hp = MAX_HP; level = 1; level_start_score = 0
	_go("res://Scenes/level.tscn")

func retry_level() -> void:
	score = level_start_score; hp = MAX_HP
	_go("res://Scenes/level.tscn")

func add_score(n: int = 1) -> void:
	score += n

func heal(n: int) -> void:
	hp = min(MAX_HP, hp + n)

func next_level() -> void:
	if level >= TOTAL_LEVELS:
		win()
		return
	level += 1
	hp = min(MAX_HP, hp + 10)
	level_start_score = score
	_go("res://Scenes/level.tscn")

func game_over() -> void: _go("res://Scenes/gameover.tscn")
func win() -> void: _go("res://Scenes/win.tscn")
func go_menu() -> void: _go("res://Scenes/menu.tscn")
func go_credit() -> void: _go("res://Scenes/credit.tscn")

func _go(path: String) -> void:
	get_tree().change_scene_to_file.call_deferred(path)
