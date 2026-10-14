# ลูกแสง (กระสุน) ของผู้เล่น ฆ่าผีได้
extends Area2D

var dir := 1
var life := 1.2

func _ready() -> void:
	add_to_group("bullet")
	collision_layer = 4
	collision_mask = 1
	var s := Sprite2D.new()
	s.texture = load("res://Assets/Sprites/bullet.png")
	add_child(s)
	var cs := CollisionShape2D.new()
	var c := CircleShape2D.new()
	c.radius = 9
	cs.shape = c
	add_child(cs)
	body_entered.connect(func(_b): queue_free())

func _physics_process(d: float) -> void:
	position.x += dir * 640.0 * d
	life -= d
	if life <= 0.0: queue_free()
