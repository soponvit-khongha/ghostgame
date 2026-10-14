# หน้า Credit  ** แก้รหัส/ชื่อ-สกุล ของคุณที่ตัวแปร TEAM ด้านล่าง **
extends Control

const UI := preload("res://Scripts/ui_util.gd")
const TEAM := [
	"1. นายโสภณวิทย์ คงหา  รหัส 683380453-8",
]

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	UI.background(self)
	UI.label(self, "GHOST RUN", 64, Vector2(0, 40), Color(1, 0.95, 0.6))
	UI.label(self, "Computer Game Development Course 2026", 30, Vector2(0, 140))
	UI.label(self, "College of Computing, Khon Kaen University", 26, Vector2(0, 185))
	UI.label(self, "By Asst.Dr. Wachirawut Thamviset", 24, Vector2(0, 225), Color(0.8, 0.9, 1))
	UI.label(self, "Development Team", 40, Vector2(0, 300), Color(1, 0.4, 0.5))
	for i in TEAM.size():
		UI.label(self, TEAM[i], 28, Vector2(0, 360 + i * 40))
	UI.sprite(self, "player", 6, Vector2(300, 440), 3.0).frame = 0
	UI.sprite(self, "ghost_white", 2, Vector2(860, 440), 2.5)
	UI.button(self, "Back", func(): GameManager.go_menu(), Vector2(20, 20))
