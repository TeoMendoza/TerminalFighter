## Overview

A local multiplayer 2D fighting game built in Godot. Choose your fighter, match with a friend over LAN, and battle it out using distinct abilities. The game features two unique characters, responsive controls, and an in-house matchmaking system for playing.

## Getting Started

### 1. Start the Matchmaking Server

Before launching the game, you must run the included matchmaking server. You will need to adjust the **URL** variable in the **Join Game** function in the **Main.gd** script to ensure connections can be made.

- Make sure you have **Python** and **Flask** installed.

> **Note:** This server currently supports **LAN (same network)** connections only.

### 2. Launch the Game

Open **Terminal Fighter** in Godot or run the exported binary. From the main menu:

- **Choose your character**: each has a unique playstyle and set of abilities.
- Once selected, you may **search for a match**. You’ll be locked into this character for the match until returning to the main menu.
- The game will **connect you to an available opponent automatically**.

After each match, you’ll be returned to the lobby. There’s no need to restart the game or server, just find a new match and play again!

## Additional Tips

- If performance becomes sluggish, check your network connection.
- Restarting both the matchmaking server and game client can help resolve any temporary issues.
- On first-time setup, it’s recommended that the player running the matchmaking server initiates the first match. This ensures proper IP assignment and prevents connection errors. After the first match, either player may initiate matchmaking.

## Developer's Note

Hey there! Thanks for checking out **Terminal Fighter**.

This project began in February as a side passion while balancing two jobs and full-time school. Progress was slow at first, but over spring break I finally found the time to build out the first character, The Ninja, and implement online play. The second character, The Sumo, came together much faster thanks to that early groundwork.

Though I’ve poured a lot into this project, I’m now stepping away to start something new, **3D Free For All Fighter Game Built With Unity & Spacetime DB**. It's quite a big step up from this game, but I’m excited about where it’s going. 

**Stay tuned enjoy playing!**

Teo

## Additional Documentation
- [Characters](Characters.md)
- [Design Retrospective](DesignRetrospective.md)
