# แผ่นเลื่อน (Moving Platform) เลื่อนซ้าย-ขวา
extends AnimatableBody2D

var origin := Vector2.ZERO
var t := 0.0

func _ready() -> void:
	sync_to_physics = true
	collision_layer = 1
	collision_mask = 0
	var s := Sprite2D.new()
	s.texture = load("res://Assets/Sprites/platform_m.png")
	add_child(s)
	var cs := CollisionShape2D.new()
	var r := RectangleShape2D.new()
	r.size = Vector2(128, 24)
	cs.shape = r
	add_child(cs)
	origin = position

func _physics_process(d: float) -> void:
	t += d
	position.x = origin.x + sin(t * 1.2) * 128.0
