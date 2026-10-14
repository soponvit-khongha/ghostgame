# เมนูหลัก: Start / Option / Credit / Exit
extends Control

const UI := preload("res://Scripts/ui_util.gd")
var main_box: Control
var opt_box: Control
var ghosts: Array = []
var t := 0.0

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	UI.background(self)
	UI.label(self, "GHOST RUN", 84, Vector2(0, 50), Color(1, 0.95, 0.6))
	UI.label(self, "Run away from the ghosts!", 28, Vector2(0, 160), Color(0.8, 0.8, 1))
	main_box = Control.new(); add_child(main_box)
	UI.button(main_box, "Start", func(): GameManager.new_game(), Vector2(446, 240))
	UI.button(main_box, "Option", func(): _show_opt(true), Vector2(446, 310))
	UI.button(main_box, "Credit", func(): GameManager.go_credit(), Vector2(446, 380))
	UI.button(main_box, "Exit", func(): get_tree().quit(), Vector2(446, 450))
	opt_box = Control.new(); add_child(opt_box); opt_box.visible = false
	var mb := UI.button(opt_box, "", func(): pass, Vector2(446, 260))
	var sb := UI.button(opt_box, "", func(): pass, Vector2(446, 330))
	var upd := func():
		mb.text = "Music: " + ("ON" if AudioManager.music_on else "OFF")
		sb.text = "SFX: " + ("ON" if AudioManager.sfx_on else "OFF")
	mb.pressed.connect(func(): AudioManager.set_music(not AudioManager.music_on); upd.call())
	sb.pressed.connect(func(): AudioManager.sfx_on = not AudioManager.sfx_on; AudioManager.play("coin"); upd.call())
	UI.button(opt_box, "Back", func(): _show_opt(false), Vector2(446, 400))
	upd.call()
	for i in 4:
		var kinds := ["ghost_white", "ghost_red", "ghost_purple", "ghost_white"]
		var g := UI.sprite(self, kinds[i], 2, Vector2(120 + i * 300, 500), 1.5)
		ghosts.append(g)
	UI.sprite(self, "player", 6, Vector2(1020, 560), 2.0).frame = 0
	AudioManager.play_music()

func _show_opt(on: bool) -> void:
	main_box.visible = not on
	opt_box.visible = on

func _process(d: float) -> void:
	t += d
	for i in ghosts.size():
		ghosts[i].position.y = 520 + sin(t * 2.0 + i) * 24
		ghosts[i].frame = int(t * 4.0) % 2
