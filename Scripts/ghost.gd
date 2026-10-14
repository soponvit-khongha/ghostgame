# ผี: g ผีขาว(ตามติด) r ผีแดง(เร็ว) p ผีม่วง(ลอยไปมา) B ผียักษ์(ไล่ล่า ต้องยิง/เหยียบหลายครั้ง)
extends Area2D

var kind := "g"
var hp := 1
var t := 0.0
var spd := 90.0
var origin := Vector2.ZERO
var sprite: Sprite2D
var dying := false
var stomp_cd := 0.0

func _ready() -> void:
	collision_layer = 8
	collision_mask = 2 | 4
	sprite = Sprite2D.new()
	sprite.hframes = 2
	var r := 22.0
	match kind:
		"g": sprite.texture = load("res://Assets/Sprites/ghost_white.png"); spd = 90.0
		"r": sprite.texture = load("res://Assets/Sprites/ghost_red.png"); spd = 150.0
		"p": sprite.texture = load("res://Assets/Sprites/ghost_purple.png"); spd = 80.0
		"B": sprite.texture = load("res://Assets/Sprites/boss.png"); spd = 170.0; hp = 10; r = 62.0
	sprite.z_index = 5
	add_child(sprite)
	var cs := CollisionShape2D.new()
	var c := CircleShape2D.new()
	c.radius = r
	cs.shape = c
	add_child(cs)
	origin = position
	t = randf() * 6.0
	area_entered.connect(_on_area)

func _physics_process(d: float) -> void:
	if dying: return
	t += d
	stomp_cd = maxf(stomp_cd - d, 0.0)
	sprite.frame = int(t * 4.0) % 2
	var pl := get_tree().get_first_node_in_group("player")
	if pl == null or pl.dead: return
	var to: Vector2 = pl.global_position - global_position
	match kind:
		"g", "r":
			if to.length() < (520.0 if kind == "g" else 650.0):
				position += to.normalized() * spd * d
			sprite.position.y = sin(t * 3.0) * 6.0
		"p":
			position.x = origin.x + sin(t * 1.1) * 160.0
			position.y = origin.y + sin(t * 2.2) * 30.0
		"B":
			if t > 2.0:
				position.x += spd * d
				position.y = lerpf(position.y, pl.global_position.y - 10.0, 1.5 * d)
	sprite.flip_h = to.x > 0.0
	for b in get_overlapping_bodies():
		if not b.is_in_group("player") or b.dead: continue
		var stomp: bool = b.velocity.y > 50.0 and b.global_position.y < global_position.y - 8.0
		if stomp:
			if stomp_cd <= 0.0:
				stomp_cd = 0.3
				b.velocity.y = -480.0
				AudioManager.play("stomp")
				take(3 if kind == "B" else 1)
		else:
			b.hurt(15 if kind == "B" else 5)

func _on_area(a: Area2D) -> void:
	if a.is_in_group("bullet"):
		a.queue_free()
		take(1)

func take(n: int) -> void:
	if dying: return
	hp -= n
	sprite.modulate = Color(3, 3, 3)
	get_tree().create_timer(0.08).timeout.connect(func(): if is_instance_valid(sprite): sprite.modulate = Color.WHITE)
	if hp <= 0: die()

func die() -> void:
	dying = true
	GameManager.add_score(10 if kind == "B" else 2)
	AudioManager.play("stomp")
	var p := CPUParticles2D.new()
	p.position = position
	p.one_shot = true; p.amount = 24; p.lifetime = 0.7; p.explosiveness = 1.0
	p.direction = Vector2(0, -1); p.spread = 180.0
	p.initial_velocity_min = 100.0; p.initial_velocity_max = 260.0
	p.gravity = Vector2(0, 500)
	p.scale_amount_min = 3.0; p.scale_amount_max = 6.0
	p.color = Color(1, 0.85, 0.4) if kind != "B" else Color(0.8, 0.3, 1.0)
	p.emitting = true
	get_parent().add_child(p)
	get_tree().create_timer(1.2).timeout.connect(p.queue_free)
	queue_free()
