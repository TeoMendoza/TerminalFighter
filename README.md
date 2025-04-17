# 🥋 Terminal Fighter

A local multiplayer 2D fighting game built in Godot. Choose your fighter, match with a friend over LAN, and battle it out using distinct abilities. The game features two unique characters, responsive controls, and an in-house matchmaking system for playing.

---

## 🚀 Getting Started

### 1. Start the Matchmaking Server

Before launching the game, you must run the included matchmaking server.

- Make sure you have **Python** and **Flask** installed.

> 🔗 **Note:** This server currently supports **LAN (same network)** connections only.

---

### 2. Launch the Game

Open **Terminal Fighter** in Godot or run the exported binary. From the main menu:

- **Choose your character**: each has a unique playstyle and set of abilities.
- Once selected, you may **search for a match**. You’ll be locked into this character for the match until returning to the main menu.
- The game will **connect you to an available opponent automatically**.

✅ After each match, you’ll be returned to the lobby. There’s no need to restart the game or server — just find a new match and play again!

---

## 🧠 Additional Tips

- If performance becomes sluggish, check your network connection.
- Restarting both the matchmaking server and game client can help resolve any temporary issues.
- On first-time setup, it’s recommended that the player running the matchmaking server initiates the first match. This ensures proper IP assignment and prevents connection errors. After the first match, either player may initiate matchmaking.

---

## 🧍‍♂️ Character Overviews

Each fighter in **Terminal Fighter** comes with a unique playstyle, stats, and abilities. While all characters share some basic rules and structure, their differences create dynamic and strategic matchups.

---

### 🧩 Shared Traits

- **Health:** All characters start with 120 HP.
- **Abilities:** Each character has 1 passive ability and 2 active abilities (bound to `E` and `Right Mouse Button`/`F`).
- **Attacks:** All characters use projectile attacks that deal damage when aimed and landed precisely. Abilities do not deal damage directly but help you land your attacks.

#### Controls

- **Jump:** Hold `Space` to control jump height.
- **Shoot:** Projectiles are fired toward the cursor using `Left Mouse Button`.
- **Projectiles:** No gravity/drop-off; fixed speed and limited lifetime.
- **Movement & Aiming:** Move in one direction while aiming/shooting in another. An aiming indicator helps opponents track your direction.

#### Characters differ in:

- Abilities  
- Movement speed  
- Jump height  
- Projectile speed and size  
- Hitbox dimensions  
- Cooldown durations

---

### 🥷 Ninja — Mobile, Agile, and Outplay-Focused

The Ninja excels in evasion, counterplay, and quick repositioning. Light but deadly in the right hands.

#### Passive — Double Jump

- Refreshes whenever you touch the ground.

#### Ability 1 — Dash (`E`)

- Invulnerable dash in your movement direction.  
- Can phase through attacks and abilities, but not through solid objects or players.  
- **Reset animation:** Smoke cloud

#### Ability 2 — Block (`Right Mouse Button` / `F`)

- Reflect incoming projectiles **only if facing them**.  
- Movement is slowed during block.  
- Perfect for baits and aggressive parries.  
- **Reset animation:** Sparks

#### Attack — Shuriken (`Left Mouse Button`)

- Fast, small projectile.  
- **Damage:** 20  
- **Reset animation:** Slash

---

### 💪 Sumo — Heavy, Durable, and Punishing

The Sumo thrives on close-range pressure and rewards patient, reactive play. Great for those who want to control the fight.

#### Passive — Comeback Tank

- Below 40 HP, Sumo becomes faster.  
- In mirror matches, receives reduced knockback and stun duration, allowing quicker counterattacks.

#### Ability 1 — Carb Up (`Right Mouse Button` / `F`)

- Temporary 1.5-second speed boost.  
- Incoming damage reduced to 10 flat per projectile.  
- Can be used while other abilities are active.

#### Ability 2 — Slam (`E`)

- Aerial-only move. Slams the ground and stuns/knocks back enemies.

**Types of Slams:**

- **Quick Slam:** Short jump followed by vertical slam. Fast, light knockback.  
- **High Quick Slam:** Tall jump, aim cursor below. Still vertical, but builds stronger knockback.  
- **Long Slam:** Aim cursor away from your character for diagonal/horizontal slam. Used to reach distant targets.

#### Attack — Coin Bag (`Left Mouse Button`)

- Slower but heavier projectile.  
- **Damage:** 30

---

## ✍️ Developer's Note

Hey there! Thanks for checking out **Terminal Fighter**.

This project began in February as a side passion while balancing two jobs and full-time school. Progress was slow at first, but over spring break I finally found the time to build out the first character, The Ninja, and implement online play. The second character, The Sumo, came together much faster thanks to that early groundwork.

Though I’ve poured a lot into this project, I’m now stepping away to start something new — a **narrative-driven 3D Murder Mystery** project I'm building with a close friend. It's a big shift from this game, but I’m excited about where it’s going.

**Stay tuned, and most importantly, enjoy playing! 🙌**

— Teo
