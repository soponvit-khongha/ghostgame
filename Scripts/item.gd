# ไอเท็ม: c เหรียญ, h หัวใจ(+พลังชีวิต), s ความเร็ว, j กระโดดสูง
extends Area2D

var kind := "c"
var t := 0.0
var sprite: Sprite2D

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	var tex := {"c": "coin", "h": "heart", "s": "speed", "j": "jump"}
	sprite = Sprite2D.new()
	sprite.texture = load("res://Assets/Sprites/%s.png" % tex[kind])
	add_child(sprite)
	var cs := CollisionShape2D.new()
	var c := CircleShape2D.new()
	c.radius = 18
	cs.shape = c
	add_child(cs)
	t = randf() * 6.0
	body_entered.connect(_on_body)

func _process(d: float) -> void:
	t += d
	sprite.position.y = sin(t * 4.0) * 4.0

func _on_body(b: Node) -> void:
	if not b.is_in_group("player"): return
	match kind:
		"c":
			GameManager.add_score(1); AudioManager.play("coin")
		"h":
			GameManager.heal(10); AudioManager.play("power")
		"s":
			b.boost_t = 6.0; AudioManager.play("power")
		"j":
			b.jboost_t = 8.0; AudioManager.play("power")
	queue_free()
