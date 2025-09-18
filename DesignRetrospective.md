# Terminal Fighter - Design Retrospective

## 1. Overview
Terminal Fighter was my first complete game project, developed over six weeks in Spring 2024. It’s a 2D multiplayer fighting game featuring two unique characters, each with a distinct kit of abilities. 

My primary goal was to explore the fundamentals of fighting game design, fast-paced combat loops, character kits, and moment-to-moment decision making, while gaining the experience of fully shipping a playable build.  

## 2. Design Goals & Intent
I wanted players to experience a fighting game that felt simple to learn but rewarding to master. Matches should be short and accessible to casual players, while also offering enough depth to support high-skill play.  

Key inspirations included *Super Smash Bros* and *Multiversus*. Unlike those titles, I aimed for a visually minimal design with little to no HUD, relying instead on in-game effects and character feedback for clarity.  

## 3. Core Systems & Mechanics

### Combat Loop
- Each character has a basic attack paired with mobility stats (speed, jump height, hitbox).  
- Abilities are multi-purpose tools, usable both offensively and defensively.  
- The map introduces additional strategy, obstacles can be leveraged for positioning, pressure, or defense.  

**Design Reasoning:**  
With only two characters, I avoided creating counter-pick scenarios. Instead, both kits were built with equally strong offensive and defensive options, ensuring that matchups came down to execution rather than inherent advantage.  

### Characters

#### Ninja
- **Concept:** A fast, agile character built around mobility and outplay potential.  
- **Abilities:**  
  - **Passive:** Double Jump – improves mobility and outplay potential.  
  - **Active 1:** Dash – can be used aggressively to close distance or defensively to escape.  
  - **Active 2:** Block – a versatile tool that turns defense into offense, enabling counterplay.  
- **Strengths:** Can bait opponents into bad positions, then capitalize with quick movement and reactive abilities. Offers high skill expression for advanced players.  
- **Weaknesses:** Low damage output makes it difficult to finish opponents. Requires consistent, well-timed ability use to stay competitive, which can feel unrewarding for casual players.  

#### Goblin
- **Concept:** A reckless, high-damage character with a chaotic, energetic playstyle.  
- **Abilities:**  
  - **Passive:** Last Stand – when below 25% HP, gains a permanent speed increase. This makes him more mobile in late fights and enhances punish potential with abilities like Slam.  
  - **Active 1:** Slam – a high-impact, stun-heavy ability for punishing opponents.  
  - **Active 2:** Carb Up – temporarily reduces incoming damage and boosts movement speed, allowing reckless but forgiving play.  
- **Strengths:** Feels powerful and fun to play. The kit is forgiving to less technical players, while still enabling fast-paced punishes for skilled ones. Carb Up gives him strong defensive flexibility, and the passive ensures exciting comebacks.  
- **Weaknesses:** Relatively stationary outside of Carb Up and passive speed buff. Vulnerable once abilities are on cooldown. Has fewer creative outplay options compared to Ninja, which limited his long-term depth.  

## 4. Strengths (What Worked)
- **Abilities felt rewarding** — testers consistently enjoyed using abilities to outplay opponents. Kits complemented mobility and created distinct playstyles.  
- **Time-to-kill was well-balanced** — matches felt tense, with comeback potential even after mistakes. This created a satisfying back-and-forth rather than “first hit wins.”  
- **Playtest validation** — friends and classmates praised the uniqueness and polish of abilities, noting the high skill ceiling and satisfying outplay potential.  

## 5. Weaknesses (What Didn’t Work)
- **Basic attack design** — intended as a high-damage reward after smart ability use, but it felt sluggish and punishing. A lower-damage, clip-based system would have better matched the game’s fast pace.  
- **HUD-free readability** — while immersive in concept, the cooldown effects at player feet were difficult to interpret. Problems included:  
  - Linking effects to specific abilities was unintuitive.  
  - Visual polish was lacking, reducing clarity.  
  - No audio feedback, which left players guessing.  
- **Development constraints** — as my first shipped game, I underestimated the complexity of multiplayer. Using client authority caused desync issues, making features like bullet drop impractical. The lack of modular systems also prevented me from expanding beyond two characters.  

## 6. Iterations & Trade-offs
- **Ability reworks:**  
  - Early Goblin kit included a rock slam projectile, but it overlapped too heavily with Goblin Slam and made the character feel one-dimensional. Cutting it forced the kit to diversify.  
  - Ninja originally had Double Jump as an active ability, but it limited design space when paired with Dash. I shifted Double Jump into a **passive** and introduced **Block** as a second active ability, giving the kit more versatility and outplay potential.  
- **Playtesting approach:** Initially I built too much before testing, resulting in tangled issues. Switching to small, iterative tests (one friend at a time, per ability) gave clearer, more actionable feedback.  
- **HUD trade-off:** I compromised with cooldown effects around characters, but they were neither clear nor satisfying. This taught me the importance of sound and visual UX in minimal HUD designs.  
- **Scope cuts:** I planned five characters but shipped two. The lack of modular systems and exponential interactions between abilities made additional characters unrealistic within scope.  

## 7. Lessons Learned
- **Design principles:**  
  - Auditory and visual feedback must complement each other; one without the other undermines clarity.  
  - Modular, well-planned systems are essential for scalability.  
  - Every mechanic must consider both positives and negatives; trade-offs make systems interesting.  
  - Playtesting early and often is invaluable. Iteration is smoother when feedback arrives in small, focused batches.  
- **Technical lessons:**  
  - Multiplayer development is far more complex than expected. Client authority causes issues with fairness and feel; server authority, while harder, is the right long-term choice.  
- **Personal growth:**  
  - Scope realistically — finishing a smaller, polished game is more valuable than overreaching.  
  - UI/UX is as important as mechanics. Even great abilities feel flat if they aren’t communicated effectively.  

## 8. Future Work
- Redesign with server authority to improve responsiveness and fairness.  
- Revisit HUD design with minimal but clear visual/audio cues.  
- Expand character roster on a modular foundation to enable diverse matchups.  

**Legacy:**  
Although Terminal Fighter itself is complete, it directly informed my current project: a 3D FFA Fighter with server authority and deeper system planning. Terminal Fighter served as the foundation for my growth in both design thinking and technical execution.  
