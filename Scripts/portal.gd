# ประตูวาร์ป: ไปด่านถัดไป (ด่านสุดท้าย = ชนะเกม)
extends Area2D

var t := 0.0
var used := false
var sprite: Sprite2D

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	sprite = Sprite2D.new()
	sprite.texture = load("res://Assets/Sprites/portal.png")
	sprite.position.y = -16
	add_child(sprite)
	var cs := CollisionShape2D.new()
	var r := RectangleShape2D.new()
	r.size = Vector2(40, 88)
	cs.shape = r
	cs.position.y = -16
	add_child(cs)
	body_entered.connect(_on_body)

func _process(d: float) -> void:
	t += d
	sprite.scale = Vector2.ONE * (1.0 + sin(t * 5.0) * 0.06)

func _on_body(b: Node) -> void:
	if used or not b.is_in_group("player") or b.dead: return
	used = true
	AudioManager.play("portal")
	GameManager.next_level()
