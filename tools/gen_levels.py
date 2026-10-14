# สร้าง Scripts/level_data.gd (แผนที่ 4 ด่านแบบ ASCII)  รัน: python3 tools/gen_levels.py
# # พื้น | = อิฐลอย | P ผู้เล่น | c เหรียญ | h หัวใจ | s ความเร็ว | j กระโดดสูง | ^ หนาม | f ไฟ | w เลื่อยวง
# g ผีขาว(ตามติด) | r ผีแดง(เร็ว) | p ผีม่วง(ลอยไปมา) | B ผียักษ์ไล่ล่า | T กระดานเด้ง | M แผ่นเลื่อน | E ประตูวาร์ป
ROWS = 12
class G:
    def __init__(s, w): s.w = w; s.g = [[' ']*w for _ in range(ROWS)]
    def put(s, x, y, ch): s.g[y][x] = ch
    def ground(s, x0, x1, top=10):
        for y in range(top, ROWS):
            for x in range(x0, x1+1): s.g[y][x] = '#'
    def gap(s, x, w):
        for y in range(10, ROWS):
            for i in range(w): s.g[y][x+i] = ' '
    def plat(s, x, y, n, ch='='):
        for i in range(n): s.g[y][x+i] = ch
    def row(s, x0, x1, y, ch='c'):
        for x in range(x0, x1+1): s.g[y][x] = ch
    def out(s): return ["".join(r) for r in s.g]

def L1():
    g = G(72); g.ground(0, 71); g.gap(18, 2); g.gap(34, 3)
    g.put(2, 9, 'P'); g.row(5, 9, 8)
    g.plat(12, 8, 3); g.row(12, 14, 7); g.put(13, 6, 'h')
    g.row(18, 19, 8); g.put(26, 9, '^'); g.put(27, 9, '^'); g.row(25, 28, 7)
    g.row(34, 36, 8); g.put(30, 8, 'g'); g.put(50, 8, 'g'); g.put(60, 8, 'g')
    g.plat(40, 8, 3); g.plat(45, 6, 3); g.row(40, 42, 7); g.row(45, 47, 5); g.put(46, 4, 'h')
    g.put(55, 9, 's'); g.row(56, 62, 9); g.put(66, 9, 'j'); g.put(69, 9, 'E')
    return g.out()
def L2():
    g = G(90); g.ground(0, 89); g.gap(14, 3); g.gap(30, 2); g.gap(40, 6)
    g.put(2, 9, 'P'); g.row(4, 8, 8); g.row(14, 16, 8); g.put(20, 9, 'f'); g.row(19, 21, 8)
    g.plat(26, 8, 3); g.row(26, 28, 7); g.put(27, 6, 'h'); g.put(24, 9, 'g'); g.row(30, 31, 8)
    g.put(35, 8, 'g'); g.put(42, 10, 'M'); g.row(41, 45, 8, 'c')
    g.plat(50, 8, 3); g.row(50, 52, 7); g.put(56, 9, '^'); g.put(57, 9, '^'); g.put(58, 9, '^'); g.row(55, 59, 8)
    g.put(60, 8, 'r'); g.put(65, 9, 's'); g.put(70, 7, 'p'); g.put(74, 9, 'w'); g.put(80, 8, 'r'); g.put(83, 9, 'j')
    g.row(66, 69, 9); g.put(87, 9, 'E')
    return g.out()
def L3():
    g = G(100); g.ground(0, 99); g.gap(12, 3); g.gap(26, 3); g.gap(38, 2); g.gap(60, 4)
    g.put(2, 9, 'P'); g.put(18, 9, 'w'); g.row(12, 14, 8); g.put(22, 6, 'p'); g.row(26, 28, 8)
    g.put(34, 9, 'f'); g.put(35, 9, 'f'); g.row(33, 36, 8); g.row(38, 39, 8)
    g.plat(44, 8, 3); g.plat(48, 6, 3); g.row(48, 50, 5); g.put(49, 4, 'h'); g.put(40, 8, 'g')
    g.put(53, 9, 'w'); g.put(56, 5, 'p'); g.put(64, 9, 'T'); g.plat(66, 5, 4); g.row(66, 69, 4); g.put(67, 3, 'h')
    g.row(60, 63, 8); g.put(72, 8, 'r'); g.put(76, 9, '^'); g.put(77, 9, '^'); g.row(75, 78, 7)
    g.put(82, 9, 's'); g.put(85, 8, 'r'); g.put(90, 9, 'w'); g.put(93, 9, 'j'); g.put(97, 9, 'E')
    return g.out()
def L4():
    g = G(120); g.ground(0, 119)
    for x, w in ((15, 2), (30, 3), (48, 3), (64, 2), (80, 3), (96, 6)): g.gap(x, w)
    g.put(8, 9, 'P'); g.put(1, 7, 'B'); g.put(10, 9, 's'); g.row(15, 16, 8)
    g.put(22, 9, '^'); g.put(23, 9, '^'); g.put(26, 9, 'f'); g.row(30, 32, 8); g.put(35, 9, 'h')
    g.put(40, 9, '^'); g.put(41, 9, '^'); g.put(44, 9, 'f'); g.put(45, 7, 'r'); g.row(48, 50, 8)
    g.put(53, 9, 'w'); g.put(56, 9, '^'); g.put(57, 9, '^'); g.put(58, 9, '^'); g.put(60, 9, 'f'); g.put(61, 9, 'f')
    g.row(64, 65, 8); g.put(69, 8, 'g'); g.put(70, 9, 'h'); g.put(72, 9, '^'); g.put(76, 9, 'w'); g.put(85, 9, 's')
    g.row(80, 82, 8); g.put(88, 9, '^'); g.put(89, 9, '^'); g.put(92, 8, 'r'); g.put(98, 10, 'M'); g.row(97, 101, 8)
    g.put(105, 9, 'j'); g.put(108, 9, 'f'); g.put(112, 9, '^'); g.put(115, 8, 'r'); g.put(118, 9, 'E')
    return g.out()
with open("Scripts/level_data.gd", "w") as f:
    f.write("# สร้างอัตโนมัติจาก tools/gen_levels.py (แก้แผนที่ที่นั่นแล้วรันใหม่ หรือแก้ตรงนี้ได้เลย)\nextends RefCounted\n\nconst LEVELS := [\n")
    for L in (L1(), L2(), L3(), L4()):
        f.write("\t[\n" + ",\n".join('\t\t"%s"' % r for r in L) + "\n\t],\n")
    f.write("]\n")
print("levels ok")
