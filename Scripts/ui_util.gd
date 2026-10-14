# ตัวช่วยสร้าง UI ด้วยโค้ด
extends RefCounted

static func background(parent: Control) -> void:
	for n in ["bg_sky", "bg_hills", "bg_trees"]:
		var tr := TextureRect.new()
		tr.texture = load("res://Assets/Sprites/%s.png" % n)
		tr.position = Vector2.ZERO
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(tr)

static func label(parent: Node, text: String, size: int, pos: Vector2, color := Color.WHITE, w := 1152.0) -> Label:
	var l := Label.new()
	l.text = text
	l.position = pos
	l.size = Vector2(w, size * 1.5)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_outline_color", Color(0.1, 0, 0.2))
	l.add_theme_constant_override("outline_size", 8)
	parent.add_child(l)
	return l

static func button(parent: Node, text: String, cb: Callable, pos: Vector2) -> Button:
	var b := Button.new()
	b.text = text
	b.position = pos
	b.custom_minimum_size = Vector2(260, 56)
	b.size = Vector2(260, 56)
	b.add_theme_font_size_override("font_size", 26)
	b.pressed.connect(cb)
	parent.add_child(b)
	return b

static func sprite(parent: Node, tex: String, hframes: int, pos: Vector2, scale := 1.0) -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = load("res://Assets/Sprites/%s.png" % tex)
	s.hframes = hframes
	s.position = pos
	s.scale = Vector2.ONE * scale
	parent.add_child(s)
	return s
