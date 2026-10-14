# สร้างภาพ (sprite) และเสียง ของเกม Ghost Run ด้วย Python (PIL) - รันซ้ำได้: python3 tools/gen_assets.py
import math, random, struct, wave
from PIL import Image, ImageDraw
random.seed(7)
S = "Assets/Sprites/"; A = "Assets/Sound/"

def up(img, k): return img.resize((img.width*k, img.height*k), Image.NEAREST)

def tiles():
    im = Image.new("RGBA", (256, 64))
    d = ImageDraw.Draw(im)
    def noise(x0, base, spots):
        d.rectangle([x0, 0, x0+63, 63], fill=base)
        for _ in range(40):
            x, y = random.randint(0, 61), random.randint(0, 61)
            d.rectangle([x0+x, y, x0+x+2, y+2], fill=spots)
    dirt = (84, 58, 70, 255); dirt2 = (66, 44, 56, 255)
    noise(0, dirt, dirt2)
    for x in range(0, 64, 8): d.rectangle([x, 10, x+4, 17], fill=(70, 150, 90, 255))
    d.rectangle([0, 0, 63, 13], fill=(70, 150, 90, 255)); d.rectangle([0, 0, 63, 4], fill=(110, 200, 120, 255))
    noise(64, dirt, dirt2)
    noise(128, (96, 90, 120, 255), (76, 70, 100, 255))
    ln = (60, 55, 80, 255)
    for y in (0, 32): d.line([128, y, 191, y], fill=ln, width=3)
    for y, xs in ((0, (16, 48)), (32, (0, 32))):
        for x in xs: d.line([128+x, y, 128+x, y+32], fill=ln, width=3)
    d.rectangle([128, 0, 191, 63], outline=ln, width=2)
    noise(192, dirt, dirt2); d.rectangle([192, 0, 255, 8], fill=(150, 110, 200, 255))
    im.save(S+"tiles.png")

def player():
    sheet = Image.new("RGBA", (40*6, 56))
    for f in range(6):
        c = Image.new("RGBA", (10, 14)); d = ImageDraw.Draw(c)
        d.rectangle([3, 0, 6, 1], fill=(90, 50, 30, 255))
        d.rectangle([3, 2, 6, 4], fill=(255, 214, 170, 255))
        d.point([4, 3], fill=(20, 20, 20, 255)); d.point([6, 3], fill=(20, 20, 20, 255))
        d.rectangle([2, 5, 7, 9], fill=(60, 130, 230, 255))
        if f == 0: legs = [(3, 10, 4, 13), (5, 10, 6, 13)]; arms = [(1, 5, 1, 8), (8, 5, 8, 8)]
        elif f in (1, 3): legs = [(2, 10, 3, 13), (6, 10, 7, 13)]; arms = [(0, 6, 1, 8), (8, 6, 9, 8)]
        elif f == 2: legs = [(3, 10, 4, 13), (5, 10, 6, 12)]; arms = [(1, 5, 1, 9), (8, 5, 8, 7)]
        elif f == 4: legs = [(3, 10, 4, 12), (5, 10, 6, 13)]; arms = [(1, 5, 1, 7), (8, 5, 8, 9)]
        else: legs = [(2, 10, 3, 12), (6, 10, 7, 11)]; arms = [(0, 3, 1, 5), (8, 3, 9, 5)]
        for r in legs: d.rectangle(list(r), fill=(40, 40, 90, 255))
        for r in arms: d.rectangle(list(r), fill=(255, 214, 170, 255))
        sheet.paste(up(c, 4), (f*40, 0))
    sheet.save(S+"player.png")

def ghost(name, body, eye, px=4, boss=False):
    out = Image.new("RGBA", (12*px*2, 12*px))
    for f in range(2):
        c = Image.new("RGBA", (12, 12)); d = ImageDraw.Draw(c)
        d.ellipse([1, 0, 10, 8], fill=body); d.rectangle([1, 4, 10, 10], fill=body)
        for x in range(1, 11):
            if (x + f) % 2 == 0: d.point([x, 11], fill=body)
        d.rectangle([3, 3, 4, 5], fill=eye); d.rectangle([7, 3, 8, 5], fill=eye)
        d.point([4, 4], fill=(0, 0, 0, 255)); d.point([8, 4], fill=(0, 0, 0, 255))
        d.rectangle([3, 7, 8, 8] if boss else [4, 7, 7, 7], fill=(40, 20, 50, 255))
        out.paste(up(c, px), (f*12*px, 0))
    out.save(S+name)

def items():
    def mk(name, pix, pal, k=4):
        c = Image.new("RGBA", (len(pix[0]), len(pix)))
        for y, row in enumerate(pix):
            for x, ch in enumerate(row):
                if ch in pal: c.putpixel((x, y), pal[ch])
        up(c, k).save(S+name)
    mk("coin.png", ["..yyyy..", ".yooooy.", "yooyyooy", "yoyooyoy", "yoyooyoy", "yooyyooy", ".yooooy.", "..yyyy.."],
       {"y": (255, 220, 60, 255), "o": (230, 160, 20, 255)})
    mk("heart.png", [".rr..rr.", "rwrrrrrr", "rrrrrrrr", "rrrrrrrr", ".rrrrrr.", "..rrrr..", "...rr...", "........"],
       {"r": (230, 50, 80, 255), "w": (255, 190, 200, 255)})
    mk("speed.png", ["....bb..", "...bbb..", "..bbb...", ".bbbbbb.", "...bbb..", "..bb....", "..b.....", "........"], {"b": (80, 200, 255, 255)})
    mk("jump.png", ["...gg...", "..gggg..", ".gggggg.", "gg.gg.gg", "...gg...", "...gg...", "...gg...", "........"], {"g": (110, 235, 110, 255)})
    im = Image.new("RGBA", (64, 40)); d = ImageDraw.Draw(im)
    for i in range(4): d.polygon([(i*16, 40), (i*16+8, 4), (i*16+16, 40)], fill=(200, 205, 225, 255), outline=(90, 90, 120, 255))
    im.save(S+"spike.png")
    im = Image.new("RGBA", (128, 64)); d = ImageDraw.Draw(im)
    for f in range(2):
        o = f*64
        d.polygon([(o+8, 64), (o+14, 28+f*6), (o+26, 50), (o+32, 6+f*8), (o+44, 48), (o+52, 24-f*4), (o+58, 64)], fill=(255, 90, 30, 255))
        d.polygon([(o+20, 64), (o+30, 34+f*4), (o+34, 22), (o+40, 40), (o+46, 64)], fill=(255, 190, 50, 255))
        d.polygon([(o+28, 64), (o+33, 44), (o+38, 64)], fill=(255, 250, 180, 255))
    im.save(S+"fire.png")
    im = Image.new("RGBA", (56, 56)); d = ImageDraw.Draw(im)
    pts = [(28+(27 if i % 2 == 0 else 19)*math.cos(i*math.pi/12), 28+(27 if i % 2 == 0 else 19)*math.sin(i*math.pi/12)) for i in range(24)]
    d.polygon(pts, fill=(170, 175, 190, 255), outline=(60, 60, 80, 255))
    d.ellipse([20, 20, 36, 36], fill=(90, 90, 110, 255)); d.ellipse([25, 25, 31, 31], fill=(30, 30, 40, 255))
    im.save(S+"saw.png")
    im = Image.new("RGBA", (64, 32)); d = ImageDraw.Draw(im)
    d.rectangle([6, 24, 58, 31], fill=(120, 80, 60, 255))
    for y in (12, 17, 22): d.line([14, y, 50, y+2], fill=(200, 200, 215, 255), width=3)
    d.rectangle([4, 4, 60, 11], fill=(230, 80, 90, 255), outline=(120, 30, 40, 255))
    im.save(S+"spring.png")
    im = Image.new("RGBA", (64, 96)); d = ImageDraw.Draw(im)
    d.ellipse([2, 2, 62, 94], fill=(70, 40, 130, 255)); d.ellipse([10, 10, 54, 86], fill=(130, 90, 230, 255))
    d.ellipse([18, 20, 46, 76], fill=(200, 170, 255, 255)); d.ellipse([26, 34, 38, 62], fill=(255, 255, 255, 255))
    im.save(S+"portal.png")
    im = Image.new("RGBA", (128, 24)); d = ImageDraw.Draw(im)
    d.rectangle([0, 0, 127, 23], fill=(120, 100, 160, 255), outline=(50, 40, 80, 255), width=3)
    d.rectangle([0, 0, 127, 7], fill=(160, 140, 210, 255))
    for x in (12, 60, 108): d.ellipse([x, 12, x+8, 20], fill=(60, 50, 90, 255))
    im.save(S+"platform_m.png")
    im = Image.new("RGBA", (24, 24)); d = ImageDraw.Draw(im)
    d.ellipse([0, 0, 23, 23], fill=(255, 250, 150, 110)); d.ellipse([5, 5, 18, 18], fill=(255, 255, 200, 255)); d.ellipse([9, 9, 14, 14], fill=(255, 255, 255, 255))
    im.save(S+"bullet.png")

def backgrounds():
    W, H = 1152, 648
    im = Image.new("RGBA", (W, H)); d = ImageDraw.Draw(im)
    for y in range(H):
        t = y/H; d.line([0, y, W, y], fill=(int(18+50*t), int(10+25*t), int(50+60*t), 255))
    for _ in range(90):
        x, y = random.randint(0, W-1), random.randint(0, 380); s = random.choice((1, 2, 2, 3))
        d.rectangle([x, y, x+s, y+s], fill=(255, 255, 230, 255))
    d.ellipse([820, 70, 940, 190], fill=(250, 245, 210, 255)); d.ellipse([850, 90, 880, 120], fill=(225, 220, 185, 255))
    im.save(S+"bg_sky.png")
    im = Image.new("RGBA", (W, H)); d = ImageDraw.Draw(im)
    d.polygon([(0, H)] + [(x, 400+50*math.sin(x*2*math.pi/W*2)+30*math.sin(x*2*math.pi/W*5)) for x in range(0, W+1, 8)] + [(W, H)], fill=(36, 26, 66, 255))
    im.save(S+"bg_hills.png")
    im = Image.new("RGBA", (W, H)); d = ImageDraw.Draw(im); base = 520
    d.polygon([(0, H), (0, base)] + [(x, base+14*math.sin(x*2*math.pi/W*3)) for x in range(0, W+1, 8)] + [(W, H)], fill=(24, 18, 44, 255))
    for x in range(80, W-80, 170):
        h = random.randint(120, 200); y0 = base-4; c = (14, 10, 28, 255)
        d.line([x, y0, x, y0-h], fill=c, width=10)
        for k in range(3):
            yy = y0-h*(0.4+0.2*k); sgn = -1 if k % 2 else 1
            d.line([x, yy, x+sgn*(40+10*k), yy-35], fill=c, width=6)
    im.save(S+"bg_trees.png")

def icon():
    open("icon.svg", "w").write('<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128"><rect width="128" height="128" fill="#1b1040"/><path d="M24 100V54a40 40 0 0 1 80 0v46l-13-10-13 10-14-10-14 10-13-10z" fill="#fff"/><circle cx="48" cy="56" r="8"/><circle cx="80" cy="56" r="8"/></svg>')

SR = 22050
def wav(name, samples):
    with wave.open(A+name, "w") as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(SR)
        w.writeframes(b"".join(struct.pack("<h", int(max(-1, min(1, s))*30000)) for s in samples))
def osc(ph, kind):
    if kind == "sq": return 1.0 if (ph % 1) < 0.5 else -1.0
    if kind == "tri": return 4*abs((ph % 1)-0.5)-1
    if kind == "noise": return random.uniform(-1, 1)
    return math.sin(2*math.pi*ph)
def sweep(f0, f1, dur, kind="sq", vol=0.4):
    n = int(SR*dur); out = []; ph = 0
    for i in range(n):
        t = i/n; ph += (f0+(f1-f0)*t)/SR; out.append(osc(ph, kind)*vol*(1-t)**0.7)
    return out
def note(f, dur, kind="sq", vol=0.3):
    n = int(SR*dur); out = []; ph = 0
    for i in range(n):
        ph += f/SR; t = i/n
        out.append(osc(ph, kind)*vol*(min(1, i/200)*(1-t)**0.6 if f > 0 else 0))
    return out
def sfx():
    wav("jump.wav", sweep(260, 620, 0.18)); wav("coin.wav", note(988, 0.07)+note(1319, 0.18))
    wav("hit.wav", sweep(220, 50, 0.3, "noise", 0.5)); wav("death.wav", sweep(500, 60, 0.7, "sq", 0.45))
    wav("shoot.wav", sweep(900, 200, 0.14, "sq", 0.3))
    wav("stomp.wav", sweep(400, 120, 0.12, "tri", 0.6)+sweep(200, 80, 0.1, "noise", 0.3))
    wav("power.wav", sum([note(f, 0.07) for f in (523, 659, 784, 1047)], []))
    wav("win.wav", sum([note(f, 0.18, "tri", 0.5) for f in (523, 659, 784, 1047, 784, 1047)], []))
    wav("gameover.wav", sum([note(f, 0.3, "tri", 0.5) for f in (392, 349, 311, 262)], []))
    wav("portal.wav", sweep(300, 1200, 0.5, "tri", 0.5))
def music():
    beat = 60/110; scale = [220, 261.6, 293.7, 329.6, 392, 440, 523.3]
    roots = [110, 110, 87.3, 98]*2; mel = []; bass = []
    for bar in range(8):
        for b in range(4): bass += note(roots[bar], beat, "tri", 0.35)
        for b in range(8): mel += note(random.choice(scale) if random.random() > 0.25 else 0, beat/2, "sq", 0.12)
    n = min(len(mel), len(bass)); wav("music.wav", [mel[i]+bass[i] for i in range(n)])

tiles(); player()
ghost("ghost_white.png", (235, 235, 255, 255), (20, 20, 60, 255))
ghost("ghost_red.png", (255, 120, 130, 255), (255, 255, 200, 255))
ghost("ghost_purple.png", (180, 130, 255, 255), (255, 255, 255, 255))
ghost("boss.png", (90, 40, 110, 255), (255, 70, 70, 255), px=12, boss=True)
items(); backgrounds(); icon(); sfx(); music()
print("assets ok")
