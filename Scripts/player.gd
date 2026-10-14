# ผู้เล่น: เด็กชายที่วิ่งหนีผี  (ลูกศร/A D = เดิน, Space/W/ขึ้น = กระโดด, X/J = ยิงลูกแสง)
extends CharacterBody2D

const BulletS := preload("res://Scripts/bullet.gd")
const SPEED := 260.0
const JUMP_V := 680.0
const GRAV := 1500.0

var level_w := 4000.0
var level_h := 768.0
var boost_t := 0.0
var jboost_t := 0.0
var inv := 0.0
var shoot_cd := 0.0
var facing := 1
var dead := false
var coyote := 0.0
var jump_buf := 0.0
var jump_was := false
var anim_t := 0.0
var sprite: Sprite2D

func _ready() -> void:
	add_to_group("player")
	collision_layer = 2
	collision_mask = 1
	var cs := CollisionShape2D.new()
	var r := RectangleShape2D.new()
	r.size = Vector2(28, 52)
	cs.shape = r
	add_child(cs)
	sprite = Sprite2D.new()
	sprite.texture = load("res://Assets/Sprites/player.png")
	sprite.hframes = 6
	add_child(sprite)
	var cam := Camera2D.new()
	cam.limit_left = 0; cam.limit_top = 0
	cam.limit_right = int(level_w); cam.limit_bottom = int(level_h)
	cam.position_smoothing_enabled = true
	cam.position_smoothing_speed = 9.0
	add_child(cam)
	cam.make_current()

func _k(code: Key) -> bool:
	return Input.is_physical_key_pressed(code)

func _physics_process(d: float) -> void:
	if dead:
		velocity.y += GRAV * d
		velocity.x = 0
		move_and_slide()
		return
	inv = maxf(inv - d, 0.0); shoot_cd = maxf(shoot_cd - d, 0.0)
	boost_t = maxf(boost_t - d, 0.0); jboost_t = maxf(jboost_t - d, 0.0)
	var dir := 0.0
	if _k(KEY_LEFT) or _k(KEY_A): dir -= 1.0
	if _k(KEY_RIGHT) or _k(KEY_D): dir += 1.0
	var spd := SPEED * (1.5 if boost_t > 0.0 else 1.0)
	velocity.x = move_toward(velocity.x, dir * spd, 2800.0 * d)
	if dir != 0.0: facing = int(dir)
	coyote = 0.1 if is_on_floor() else coyote - d
	velocity.y += GRAV * d
	var jp := _k(KEY_SPACE) or _k(KEY_UP) or _k(KEY_W) or _k(KEY_Z)
	if jp and not jump_was: jump_buf = 0.12
	jump_buf -= d
	if jump_buf > 0.0 and coyote > 0.0:
		velocity.y = -JUMP_V * (1.25 if jboost_t > 0.0 else 1.0)
		coyote = 0.0; jump_buf = 0.0
		AudioManager.play("jump")
	if not jp and velocity.y < -200.0: velocity.y += 2200.0 * d   # กระโดดสั้น/ยาวตามการกด
	jump_was = jp
	if (_k(KEY_X) or _k(KEY_J)) and shoot_cd <= 0.0:
		shoot_cd = 0.35
		var b := BulletS.new()
		b.dir = facing
		b.position = position + Vector2(facing * 26, -4)
		get_parent().add_child(b)
		AudioManager.play("shoot")
	move_and_slide()
	if global_position.y > level_h + 150.0:
		GameManager.hp = 0
		die()
	_animate(d)

func _animate(d: float) -> void:
	anim_t += d
	sprite.flip_h = facing < 0
	sprite.visible = inv <= 0.0 or int(inv * 20.0) % 2 == 0
	if not is_on_floor(): sprite.frame = 5
	elif absf(velocity.x) > 30.0: sprite.frame = 1 + int(anim_t * 12.0) % 4
	else: sprite.frame = 0
	sprite.modulate = Color(0.6, 0.9, 1.0) if boost_t > 0.0 else Color.WHITE

func hurt(n: int) -> void:
	if dead or inv > 0.0: return
	GameManager.hp -= n
	inv = 1.2
	velocity = Vector2(-facing * 220.0, -320.0)
	AudioManager.play("hit")
	if GameManager.hp <= 0: die()

func die() -> void:
	if dead: return
	dead = true
	GameManager.hp = maxi(GameManager.hp, 0)
	collision_mask = 0
	velocity = Vector2(0, -500)
	sprite.visible = true
	sprite.modulate = Color(1, 0.4, 0.4)
	AudioManager.play("death")
	get_tree().create_timer(1.4).timeout.connect(GameManager.game_over)
