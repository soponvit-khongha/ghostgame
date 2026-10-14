# HUD: แถบพลังชีวิต คะแนน ด่าน และคำใบ้
extends CanvasLayer

var fill: ColorRect
var score_l: Label
var level_l: Label
var status_l: Label
var hint: Label
var t := 0.0

func _lbl(pos: Vector2, size: int) -> Label:
	var l := Label.new()
	l.position = pos
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_outline_color", Color.BLACK)
	l.add_theme_constant_override("outline_size", 6)
	add_child(l)
	return l

func _ready() -> void:
	var back := ColorRect.new()
	back.color = Color(0, 0, 0, 0.6); back.position = Vector2(16, 16); back.size = Vector2(224, 28)
	add_child(back)
	fill = ColorRect.new()
	fill.color = Color(0.9, 0.2, 0.3); fill.position = Vector2(20, 20); fill.size = Vector2(216, 20)
	add_child(fill)
	_lbl(Vector2(250, 12), 24).text = "HP"
	score_l = _lbl(Vector2(16, 50), 28)
	level_l = _lbl(Vector2(940, 12), 28)
	status_l = _lbl(Vector2(16, 90), 20)
	hint = _lbl(Vector2(160, 560), 24)
	hint.size = Vector2(840, 60)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	match GameManager.level:
		1: hint.text = "Arrows/AD = move   SPACE = jump   X = shoot light\nStomp on ghosts! Reach the portal!"
		2: hint.text = "Spikes, fire and saws hurt! Grab the hearts!"
		3: hint.text = "Use the red springs to fly high!"
		4: hint.text = "RUN!!! The Big Ghost is chasing you!"

func _process(d: float) -> void:
	t += d
	fill.size.x = 216.0 * clampf(float(GameManager.hp) / GameManager.MAX_HP, 0.0, 1.0)
	score_l.text = "SCORE  %d" % GameManager.score
	level_l.text = "LEVEL %d/%d" % [GameManager.level, GameManager.TOTAL_LEVELS]
	hint.visible = t < 7.0
	var p := get_tree().get_first_node_in_group("player")
	var s := ""
	if p:
		if p.boost_t > 0.0: s += "SPEED UP %ds  " % ceili(p.boost_t)
		if p.jboost_t > 0.0: s += "HIGH JUMP %ds" % ceili(p.jboost_t)
	status_l.text = s
	if Input.is_physical_key_pressed(KEY_ESCAPE): GameManager.go_menu()
