# GameLab4 – Ghost Run 👻
เกม 2D Platformer Side-Scrolling สร้างด้วย Godot 4 (วิชา Computer Game Development, วิทยาลัยการคอมพิวเตอร์ มหาวิทยาลัยขอนแก่น)

**ผู้พัฒนา:** นายโสภณวิทย์ คงหา รหัสนักศึกษา 683380453-8

## Game Story
เด็กชายคนหนึ่งหลงเข้าไปในป่าต้องสาป ผีทั้งฝูงตื่นขึ้นมาไล่ล่า เขาต้องวิ่ง กระโดด หลบกับดัก เก็บเหรียญ และใช้ลูกแสงขับไล่ผี
ให้ถึงประตูวาร์ปของแต่ละด่าน ก่อนที่ **ผียักษ์** ในด่านสุดท้ายจะตามทัน!

## ตัวอย่างภาพ
<img src="docs/demo1.jpg" width="300"> <img src="docs/demo2.jpg" width="300">

## Link
- 🎬 Clip Demo VDO: *(ใส่ลิงก์ Google Drive / YouTube)*
- 🎮 Play Game: *(ใส่ GitHub Pages URL เช่น https://USERNAME.github.io/GameLab4/)*

## วิธีเล่น
| ปุ่ม | การทำงาน |
|---|---|
| ← → หรือ A D | เดิน/วิ่ง |
| Space / ↑ / W | กระโดด (กดค้าง = สูงขึ้น) |
| X หรือ J | ยิงลูกแสง |
| Esc | กลับเมนู |

เหยียบหัวผี หรือยิงลูกแสงเพื่อกำจัด (ได้คะแนน) · หัวใจ = +HP · สายฟ้า = วิ่งเร็ว · ลูกศรเขียว = กระโดดสูง · กระดานแดง = เด้ง

## สิ่งที่ทำตามแบบฝึกหัด
| ขั้นตอน | สิ่งที่ทำ |
|---|---|
| 1 | เมนู Start/Option/Credit/**Exit** (`menu.gd`), หน้า Credit (`credit.gd`) |
| 2 | ผู้เล่นใหม่ (เด็กชาย) + ศัตรู 4 ชนิด: ผีขาว (ตามติด), ผีแดง (เร็ว), ผีม่วง (ลอยไปมา), ผียักษ์ (ไล่ล่า) |
| 3 | อาวุธ: ลูกแสง (`bullet.gd`) |
| 4 | กับดัก: หนาม, ไฟ, เลื่อยวงกลม · วัตถุประกอบด่าน: แผ่นเลื่อน, กระดานเด้ง, ประตูวาร์ป |
| 5 | ไอเท็ม: เหรียญ, หัวใจ, เพิ่มความเร็ว, เพิ่มพลังกระโดด |
| 6 | 4 ด่าน สร้างด้วย **TileMapLayer + TileSet** (Tile 64x64, กำหนด Collision Polygon ให้ทุก Tile) ดู `level.gd`, `level_data.gd` |
| 7 | พื้นหลัง **Parallax** 3 ชั้น (ท้องฟ้า/เนินเขา/ต้นไม้) |
| 8 | ฉาก GameOver และ WinGame มีภาพและเสียง |
| 9 | เพลงประกอบ + เสียง Effect ทั้งหมด (สร้างด้วยโค้ด `tools/gen_assets.py`) |
| 10 | Game Play: HP / คะแนน / เหยียบผี / ชนแล้วเลือดลด |

## เผยแพร่ (Export Web + GitHub Pages)
1. Godot → Project → Export → เลือก preset **Web** → Export Project → `docs/index.html` (ติ๊ก/ปิด Export With Debug ตามต้องการ)
2. ถ่ายภาพหน้าจอเก็บไว้ที่ `docs/demo1.jpg`, `docs/demo2.jpg`
3. Commit & Push ขึ้น GitHub
4. GitHub → Settings → Pages → Branch `main` / folder `/docs` → Save
5. ใส่ลิงก์ Play Game และ VDO ใน README นี้ แล้วส่ง Link GitHub Project

## ไฟล์สำคัญ
- `Scripts/level_data.gd` – แผนที่ด่านแบบตัวอักษร (แก้ด่านได้ง่าย, สร้างจาก `tools/gen_levels.py`)
- `Scripts/credit.gd` – รายชื่อผู้พัฒนาอยู่ที่ตัวแปร `TEAM`
- `tools/gen_assets.py` – สร้างภาพและเสียงทั้งหมด (ใช้ Python + Pillow)
- ต้องใช้ Godot 4.4 ขึ้นไป (ทดสอบกับ 4.4.1, renderer: Compatibility เหมาะกับ Web)
