# ฉากจบ: GameOver (win=false) และ WinGame (win=true)
extends Control

const UI := preload("res://Scripts/ui_util.gd")
@export var win := false
var spr: Sprite2D
var t := 0.0

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	UI.background(self)
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.45); dim.size = Vector2(1152, 648)
	add_child(dim)
	if win:
		UI.label(self, "YOU ESCAPED!", 84, Vector2(0, 70), Color(1, 0.9, 0.3))
		UI.label(self, "You outran every ghost. Congratulations!", 30, Vector2(0, 175))
		spr = UI.sprite(self, "player", 6, Vector2(576, 420), 4.0)
		AudioManager.play("win")
	else:
		UI.label(self, "GAME OVER", 84, Vector2(0, 70), Color(1, 0.3, 0.35))
		UI.label(self, "The ghosts got you...", 30, Vector2(0, 175))
		spr = UI.sprite(self, "ghost_white", 2, Vector2(576, 420), 4.0)
		AudioManager.play("gameover")
	UI.label(self, "SCORE: %d" % GameManager.score, 44, Vector2(0, 230), Color(1, 0.95, 0.6))
	if win:
		UI.button(self, "Play Again", func(): GameManager.new_game(), Vector2(300, 560))
	else:
		UI.button(self, "Retry Level", func(): GameManager.retry_level(), Vector2(300, 560))
	UI.button(self, "Menu", func(): GameManager.go_menu(), Vector2(600, 560))

func _process(d: float) -> void:
	t += d
	if win:
		spr.position.y = 420 - absf(sin(t * 4.0)) * 80
		spr.frame = 5 if sin(t * 4.0) > 0.0 else 0
	else:
		spr.position.y = 420 + sin(t * 2.0) * 20
		spr.frame = int(t * 4.0) % 2
