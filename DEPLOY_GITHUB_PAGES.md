# วิธีขึ้นเกมบน GitHub Pages (ใช้ git เป็น host)

โฟลเดอร์ `docs/` มีเกมที่ Export เป็น Web เรียบร้อยแล้ว (index.html + index.wasm + index.pck ...)

## 1) สร้าง Repository
GitHub → New repository → ชื่อ `GameLab4` → Public → Create (ไม่ต้องติ๊ก README)

## 2) Push โปรเจกต์ (ในโฟลเดอร์ GameLab4)
```bash
git init
git add .
git commit -m "Ghost Run - GameLab4"
git branch -M main
git remote add origin https://github.com/<USERNAME>/GameLab4.git
git push -u origin main
```
(ถ้าใช้ Fork ตามแบบฝึกหัด: คัดลอกไฟล์ทั้งหมดทับใน repo ที่ Clone ไว้ แล้ว git add / commit / push)

## 3) เปิด GitHub Pages
Repo → Settings → Pages → Build and deployment
- Source: **Deploy from a branch**
- Branch: **main** / Folder: **/docs** → Save

รอ 1-2 นาที จะได้ลิงก์: `https://<USERNAME>.github.io/GameLab4/`

## 4) เมื่อแก้เกมแล้วอยากอัปเดต
Godot → Project → Export → Web → Export Project (ไปที่ `docs/index.html`) แล้ว
```bash
git add . && git commit -m "update" && git push
```
กด Ctrl+F5 ที่หน้าเกมเพื่อล้างแคช

## หมายเหตุ
- ใส่ภาพ `docs/demo1.jpg`, `docs/demo2.jpg` และลิงก์ในไฟล์ README.md
- ต้องคลิกที่หน้าเกมก่อน เสียงถึงจะเริ่มเล่น (ข้อจำกัดของเบราว์เซอร์)
- ทดสอบในเครื่อง: `python3 -m http.server -d docs 8000` แล้วเปิด http://localhost:8000
