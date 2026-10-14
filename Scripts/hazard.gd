# กับดัก: ^ หนาม, f ไฟ, w เลื่อยวงกลมเคลื่อนที่, T กระดานเด้ง (ไม่ใช่กับดัก)
extends Area2D

var kind := "^"
var t := 0.0
var origin := Vector2.ZERO
var sprite: Sprite2D

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	sprite = Sprite2D.new()
	add_child(sprite)
	var cs := CollisionShape2D.new()
	var shape: Shape2D
	match kind:
		"^":
			sprite.texture = load("res://Assets/Sprites/spike.png"); sprite.position.y = 12
			shape = RectangleShape2D.new(); shape.size = Vector2(48, 26); cs.position.y = 18
		"f":
			sprite.texture = load("res://Assets/Sprites/fire.png"); sprite.hframes = 2
			shape = RectangleShape2D.new(); shape.size = Vector2(36, 48); cs.position.y = 6
		"w":
			sprite.texture = load("res://Assets/Sprites/saw.png")
			shape = CircleShape2D.new(); shape.radius = 22
		"T":
			sprite.texture = load("res://Assets/Sprites/spring.png"); sprite.position.y = 16
			shape = RectangleShape2D.new(); shape.size = Vector2(54, 22); cs.position.y = 21
	cs.shape = shape
	add_child(cs)
	origin = position
	if kind == "w": t = randf() * 6.0

func _physics_process(d: float) -> void:
	t += d
	if kind == "f": sprite.frame = int(t * 8.0) % 2
	if kind == "w":
		sprite.rotation += 9.0 * d
		position.x = origin.x + sin(t * 1.6) * 128.0
	for b in get_overlapping_bodies():
		if not b.is_in_group("player") or b.dead: continue
		if kind == "T":
			if b.velocity.y > -400.0:
				b.velocity.y = -1100.0; b.coyote = 0.0
				AudioManager.play("power")
		else:
			b.hurt(10)
