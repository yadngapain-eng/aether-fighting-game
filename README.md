# Aether Fighting Game

Game fighting 2D sederhana yang dibuat dengan **Godot Engine 4.2**.

## Kontrol

| Tombol | Aksi |
|--------|------|
| A | Gerak Kiri |
| D | Gerak Kanan |
| Space | Serang |

## Fitur

- Player bisa bergerak kiri/kanan
- Player bisa menyerang dengan animasi
- Enemy AI yang mengejar dan menyerang player
- Sistem health (HP berkurang saat terkena serangan)
- Animasi sprite multi-frame

## Cara Build

### Otomatis via GitHub Actions
Setiap kali push ke branch main, GitHub Actions akan otomatis build game.

1. Buka tab Actions di repo GitHub
2. Klik workflow terbaru
3. Download artifact game-builds

### Manual
1. Install Godot 4.2.1
2. Buka project di Godot Editor
3. Klik Project - Export
4. Pilih platform dan klik Export Project

## Struktur Project

```
aether_game/
  assets/
    characters/
    backgrounds/
    ui/
  scenes/
    main.tscn
  scripts/
    main.gd
  project.godot
  export_presets.cfg
  .github/workflows/build.yml
```

## Lisensi

Aset dari sumber publik dengan lisensi bebas.