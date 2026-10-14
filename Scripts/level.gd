# สร้างด่านจากแผนที่ ASCII ใน level_data.gd (TileMapLayer + TileSet สร้างด้วยโค้ด)
extends Node2D

const TILE := 64
const PlayerS := preload("res://Scripts/player.gd")
const GhostS := preload("res://Scripts/ghost.gd")
const ItemS := preload("res://Scripts/item.gd")
const HazardS := preload("res://Scripts/hazard.gd")
const PlatformS := preload("res://Scripts/moving_platform.gd")
const PortalS := preload("res://Scripts/portal.gd")
const HudS := preload("res://Scripts/hud.gd")
const LevelData := preload("res://Scripts/level_data.gd")

var map: Array
var cols := 0
var rows := 0

func _ready() -> void:
	map = LevelData.LEVELS[GameManager.level - 1]
	rows = map.size(); cols = map[0].length()
	_build_background()
	_build_tiles()
	_build_objects()
	add_child(HudS.new())
	AudioManager.play_music()

func _build_background() -> void:
	var bg := ParallaxBackground.new()
	add_child(bg)
	for d in [["bg_sky", 0.03], ["bg_hills", 0.15], ["bg_trees", 0.4]]:
		var layer := ParallaxLayer.new()
		layer.motion_scale = Vector2(d[1], 0)
		layer.motion_mirroring = Vector2(1152, 0)
		var s := Sprite2D.new()
		s.centered = false
		s.texture = load("res://Assets/Sprites/%s.png" % d[0])
		layer.add_child(s)
		bg.add_child(layer)

func _build_tiles() -> void:
	var ts := TileSet.new()
	ts.tile_size = Vector2i(TILE, TILE)
	ts.add_physics_layer()
	ts.set_physics_layer_collision_layer(0, 1)
	var src := TileSetAtlasSource.new()
	src.texture = load("res://Assets/Sprites/tiles.png")
	src.texture_region_size = Vector2i(TILE, TILE)
	for i in 4: src.create_tile(Vector2i(i, 0))
	ts.add_source(src, 0)
	var h := TILE / 2.0
	for i in 4:   # กำหนด Collision Polygon ให้ Tile แต่ละอัน
		var td := src.get_tile_data(Vector2i(i, 0), 0)
		td.add_collision_polygon(0)
		td.set_collision_polygon_points(0, 0, PackedVector2Array([Vector2(-h, -h), Vector2(h, -h), Vector2(h, h), Vector2(-h, h)]))
	var layer := TileMapLayer.new()
	layer.name = "Ground"
	layer.tile_set = ts
	add_child(layer)
	for y in rows:
		for x in cols:
			var ch: String = map[y][x]
			if ch == "#":
				var above: String = map[y - 1][x] if y > 0 else " "
				layer.set_cell(Vector2i(x, y), 0, Vector2i(1 if above == "#" else 0, 0))
			elif ch == "=":
				layer.set_cell(Vector2i(x, y), 0, Vector2i(2, 0))

func _build_objects() -> void:
	var spawn := Vector2(2 * TILE + 32, 9 * TILE + 32)
	for y in rows:
		for x in cols:
			var ch: String = map[y][x]
			var pos := Vector2(x * TILE + 32, y * TILE + 32)
			match ch:
				"P": spawn = pos
				"c", "h", "s", "j":
					var n := ItemS.new(); n.kind = ch; n.position = pos; add_child(n)
				"^", "f", "w", "T":
					var n := HazardS.new(); n.kind = ch; n.position = pos; add_child(n)
				"g", "r", "p", "B":
					var n := GhostS.new(); n.kind = ch; n.position = pos; add_child(n)
				"M":
					var n := PlatformS.new(); n.position = Vector2(x * TILE + 64, y * TILE + 12); add_child(n)
				"E":
					var n := PortalS.new(); n.position = pos; add_child(n)
	var p := PlayerS.new()
	p.position = spawn
	p.level_w = cols * TILE
	p.level_h = rows * TILE
	add_child(p)
