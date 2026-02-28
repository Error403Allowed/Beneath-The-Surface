# Beneath The Surface
### A Campfire Hackathon Entry — Godot 4

---

## What is it?

You pilot a submarine descending into unknown waters.
The deeper you go, the darker it gets. Oxygen drains. Pressure builds. Enemies emerge.

Your mission: survive as long as possible and descend as deep as you can.

---

## How to Run

1. Download Godot 4 (if you haven't already): https://godotengine.org/download
2. Open Godot, click **Import**, and select this folder's `project.godot`
3. Hit **Play** (F5)

---

## Controls

| Action      | Keys            |
|-------------|-----------------|
| Move        | WASD / Arrow Keys |
| Fire        | Left Click / Space |

---

## Zones

| Zone          | Depth     | Danger |
|---------------|-----------|--------|
| Sunlit        | 0–200m    | Low    |
| Twilight      | 200–1000m | Medium |
| Midnight      | 1000–4000m| High   |
| Ancient Ruins | 4000m+    | Brutal |

---

## File Structure

```
scenes/
  Boot.tscn       → Loads Menu
  Menu.tscn       → Title screen
  Game.tscn       → Main gameplay
  GameOver.tscn   → Death screen

scripts/
  boot.gd
  menu.gd
  game_manager.gd     → Orchestrates everything
  player.gd           → Movement, oxygen, hull, death
  depth_manager.gd    → Zones, lighting, pressure
  enemy_spawner.gd    → Spawns enemies based on zone
  enemy_base.gd       → Patrol/Chase AI
  collectible_spawner.gd
  collectible_oxygen.gd
  collectible_repair.gd
  hud.gd
  game_over.gd
```

---

## Architecture Notes

Think of the game like a submarine itself:
- **game_manager.gd** is the captain — it wires everything together at startup
- **depth_manager.gd** is the depth gauge — it watches position and broadcasts zone changes to lighting, pressure, and spawning
- **player.gd** is the hull — it tracks all stats and emits signals when things change
- **enemy_spawner.gd** listens to the depth_manager to know how aggressively to spawn
- **hud.gd** listens to the player to display live stat updates

---

Hackathon rule #1: Ship the game.
