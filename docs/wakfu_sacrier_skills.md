# Wakfu Sacrier Skill Reference

> Source: WAKFU official encyclopedia, Sacrier class pages. Scraped on 2026-06-25.

This document is formatted as a game-design reference. Values are taken from the official level selector at Lv1, Lv50, Lv100, Lv150, Lv200, and Lv245. If a skill has no critical effect on the source page, the critical column is left as empty.

## Design Notes

- Elemental damage and armor values scale by spell level; table rows provide representative milestones instead of all 245 intermediate levels.
- Static effects such as movement, stabilization, HP percentage, WP/MP changes, and passive conditions are copied as source text.
- Flame Return, Fury, Armor, Lock, Dodge, and Punishment are source mechanics and should be mapped to local project mechanics before implementation.

## Index

- Fire Elemental Spells: Blood Rush, Bloodthirsty Fury, Burning Blood, Cage of Blood, Punition
- Air Elemental Spells: Aversion, Projection, Assault, Spiritual Tempest, Light Speed
- Earth Elemental Spells: Rocky Foot, Sacrier's Fist, Insanity, Colonnades, Smashes
- Active Specialties: Attraction, Sacrifice, Transposition, Sanguine Armor, Gash, Blood Transfer
- Passives: Blood Flow, Burning, Pillar, Motion Sick, Sacrier's Heart, Wakfu Pact, Burning Armor, Vision, Dangerous Game, Blood Trail, Clinging to Life, Smasher, Mobility, Transcendence, Libation, Blood Pact, Placidity, Wakfu Veins, Tattooed Blood, Executor

## Fire Elemental Spells

### 1. Blood Rush

- Type: Fire elemental spell
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5028-blood-rush
- Cost / Range: 3 AP, Range 1 - 1
- Cost progression: AP: 3; Range: 1 - 1
- Description: Inflicts high damage but also injures the caster.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Damage: 3 \| Flame Return : Damage: 1 | Damage: 3 \| Flame Return : Damage: 1 |
| Lv50 | Damage: 26 \| Flame Return : Damage: 8 | Damage: 33 \| Flame Return : Damage: 11 |
| Lv100 | Damage: 50 \| Flame Return : Damage: 16 | Damage: 63 \| Flame Return : Damage: 21 |
| Lv150 | Damage: 74 \| Flame Return : Damage: 24 | Damage: 93 \| Flame Return : Damage: 31 |
| Lv200 | Damage: 98 \| Flame Return : Damage: 32 | Damage: 123 \| Flame Return : Damage: 41 |
| Lv245 | Damage: 120 \| Flame Return : Damage: 40 | Damage: 150 \| Flame Return : Damage: 50 |

### 2. Bloodthirsty Fury

- Type: Fire elemental spell
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5030-bloodthirsty-fury
- Cost / Range: 2 AP, Range 1 - 3
- Cost progression: AP: 2; Range: 1 - 3
- Description: Steals health from a target.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Damage: 2 \| - 100% health stolen | Damage: 2 \| - 100% health stolen |
| Lv50 | Damage: 15 \| - 100% health stolen | Damage: 19 \| - 100% health stolen |
| Lv100 | Damage: 29 \| - 100% health stolen | Damage: 37 \| - 100% health stolen |
| Lv150 | Damage: 43 \| - 100% health stolen | Damage: 54 \| - 100% health stolen |
| Lv200 | Damage: 57 \| - 100% health stolen | Damage: 72 \| - 100% health stolen |
| Lv245 | Damage: 70 \| - 100% health stolen | Damage: 87 \| - 100% health stolen |

### 3. Burning Blood

- Type: Fire elemental spell
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5031-burning-blood
- Cost / Range: 4 AP
- Cost progression: AP: 4
- Description: Burns some of the caster's health to inflict heavy damage on nearby targets.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Damage: 5 \| Flame Return : Damage: 10% of HP max of caster | Damage: 6 \| Flame Return : Damage: 10% of HP max of caster |
| Lv50 | Damage: 36 \| Flame Return : Damage: 10% of HP max of caster | Damage: 46 \| Flame Return : Damage: 10% of HP max of caster |
| Lv100 | Damage: 69 \| Flame Return : Damage: 10% of HP max of caster | Damage: 86 \| Flame Return : Damage: 10% of HP max of caster |
| Lv150 | Damage: 101 \| Flame Return : Damage: 10% of HP max of caster | Damage: 127 \| Flame Return : Damage: 10% of HP max of caster |
| Lv200 | Damage: 134 \| Flame Return : Damage: 10% of HP max of caster | Damage: 167 \| Flame Return : Damage: 10% of HP max of caster |
| Lv245 | Damage: 163 \| Flame Return : Damage: 10% of HP max of caster | Damage: 204 \| Flame Return : Damage: 10% of HP max of caster |

### 4. Cage of Blood

- Type: Fire elemental spell
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5029-cage-blood
- Cost / Range: 4 AP, Range 1 - 2
- Cost progression: AP: 4; Range: 1 - 2
- Description: Removes MP from the target and applies a penalty on healing received.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Damage: 4 \| -3 MP \| Incurable (Lvl 4) | Damage: 5 \| -3 MP \| Incurable (Lvl 4) |
| Lv50 | Damage: 27 \| -3 MP \| Incurable (Lvl 4) | Damage: 34 \| -3 MP \| Incurable (Lvl 4) |
| Lv100 | Damage: 51 \| -3 MP \| Incurable (Lvl 4) | Damage: 64 \| -3 MP \| Incurable (Lvl 4) |
| Lv150 | Damage: 75 \| -3 MP \| Incurable (Lvl 4) | Damage: 94 \| -3 MP \| Incurable (Lvl 4) |
| Lv200 | Damage: 99 \| -3 MP \| Incurable (Lvl 4) | Damage: 124 \| -3 MP \| Incurable (Lvl 4) |
| Lv245 | Damage: 121 \| -3 MP \| Incurable (Lvl 4) | Damage: 151 \| -3 MP \| Incurable (Lvl 4) |

### 5. Punition

- Type: Fire elemental spell
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5032-punition
- Cost / Range: Range 1 - 1
- Cost progression: WP: 3; Range: 1 - 1
- Description: The caster instantly achieves their maximum berserker potential while losing all HP above 20%. Then they deal high Fire damage.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | If the Sacrier doesn't have 100 Fury: \| - Sets the Sacrier's HP to 20% \| Damage: 6 | If the Sacrier doesn't have 100 Fury: \| - Sets the Sacrier's HP to 20% \| Damage: 7 |
| Lv50 | If the Sacrier doesn't have 100 Fury: \| - Sets the Sacrier's HP to 20% \| Damage: 44 | If the Sacrier doesn't have 100 Fury: \| - Sets the Sacrier's HP to 20% \| Damage: 55 |
| Lv100 | If the Sacrier doesn't have 100 Fury: \| - Sets the Sacrier's HP to 20% \| Damage: 83 | If the Sacrier doesn't have 100 Fury: \| - Sets the Sacrier's HP to 20% \| Damage: 104 |
| Lv150 | If the Sacrier doesn't have 100 Fury: \| - Sets the Sacrier's HP to 20% \| Damage: 122 | If the Sacrier doesn't have 100 Fury: \| - Sets the Sacrier's HP to 20% \| Damage: 152 |
| Lv200 | If the Sacrier doesn't have 100 Fury: \| - Sets the Sacrier's HP to 20% \| Damage: 161 | If the Sacrier doesn't have 100 Fury: \| - Sets the Sacrier's HP to 20% \| Damage: 201 |
| Lv245 | If the Sacrier doesn't have 100 Fury: \| - Sets the Sacrier's HP to 20% \| Damage: 196 | If the Sacrier doesn't have 100 Fury: \| - Sets the Sacrier's HP to 20% \| Damage: 245 |

## Air Elemental Spells

### 6. Aversion

- Type: Air elemental spell
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5038-aversion
- Cost / Range: 4 AP, Range 1 - 3
- Cost progression: AP: 4; Range: 1 - 3
- Description: Inflicts single-target damage on an enemy. This damage is greater if the Sacrier is stabilized.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Damage: 4 \| If the Sacrier is stabilized: \| Damage: 6 instead | Damage: 5 \| If the Sacrier is stabilized: \| Damage: 7 instead |
| Lv50 | Damage: 27 \| If the Sacrier is stabilized: \| Damage: 41 instead | Damage: 34 \| If the Sacrier is stabilized: \| Damage: 51 instead |
| Lv100 | Damage: 51 \| If the Sacrier is stabilized: \| Damage: 77 instead | Damage: 64 \| If the Sacrier is stabilized: \| Damage: 96 instead |
| Lv150 | Damage: 75 \| If the Sacrier is stabilized: \| Damage: 113 instead | Damage: 94 \| If the Sacrier is stabilized: \| Damage: 141 instead |
| Lv200 | Damage: 99 \| If the Sacrier is stabilized: \| Damage: 149 instead | Damage: 124 \| If the Sacrier is stabilized: \| Damage: 186 instead |
| Lv245 | Damage: 121 \| If the Sacrier is stabilized: \| Damage: 181 instead | Damage: 151 \| If the Sacrier is stabilized: \| Damage: 227 instead |

### 7. Projection

- Type: Air elemental spell
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5041-projection
- Cost / Range: 2 AP, Range 1 - 2
- Cost progression: AP: 2; Range: 1 - 2
- Description: The Sacrier uses their target to dash forward and jump to the other side.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Damage: 2 \| teleports to the other side | Damage: 2 \| teleports to the other side |
| Lv50 | Damage: 14 \| teleports to the other side | Damage: 18 \| teleports to the other side |
| Lv100 | Damage: 27 \| teleports to the other side | Damage: 34 \| teleports to the other side |
| Lv150 | Damage: 40 \| teleports to the other side | Damage: 50 \| teleports to the other side |
| Lv200 | Damage: 53 \| teleports to the other side | Damage: 67 \| teleports to the other side |
| Lv245 | Damage: 65 \| teleports to the other side | Damage: 81 \| teleports to the other side |

### 8. Assault

- Type: Air elemental spell
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5040-assault
- Cost / Range: 1 AP, Range 1 - 5
- Cost progression: AP: 1; WP: 1; Range: 1 - 5
- Description: The caster switches places with their target, dealing some damage in the process.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Switches places \| Damage: 2 | Switches places \| Damage: 2 |
| Lv50 | Switches places \| Damage: 13 | Switches places \| Damage: 17 |
| Lv100 | Switches places \| Damage: 25 | Switches places \| Damage: 32 |
| Lv150 | Switches places \| Damage: 37 | Switches places \| Damage: 47 |
| Lv200 | Switches places \| Damage: 49 | Switches places \| Damage: 62 |
| Lv245 | Switches places \| Damage: 60 | Switches places \| Damage: 75 |

### 9. Spiritual Tempest

- Type: Air elemental spell
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5034-spiritual-tempest
- Cost / Range: 3 AP, Range 2 - 4
- Cost progression: AP: 3; Range: 2 - 4
- Description: Opponents in the area of effect suffer damage, then all fighters around the targeted cell are pushed back.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Damage: 3 \| Pushes back 1 cell | Damage: 3 \| Pushes back 1 cell |
| Lv50 | Damage: 22 \| Pushes back 1 cell | Damage: 27 \| Pushes back 1 cell |
| Lv100 | Damage: 41 \| Pushes back 1 cell | Damage: 52 \| Pushes back 1 cell |
| Lv150 | Damage: 61 \| Pushes back 1 cell | Damage: 76 \| Pushes back 1 cell |
| Lv200 | Damage: 80 \| Pushes back 1 cell | Damage: 100 \| Pushes back 1 cell |
| Lv245 | Damage: 98 \| Pushes back 1 cell | Damage: 122 \| Pushes back 1 cell |

### 10. Light Speed

- Type: Air elemental spell
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5042-light-speed
- Cost / Range: 3 AP, Range 1 - 3
- Cost progression: AP: 3; WP: 1; Range: 1 - 3
- Description: The Sacrier inflicts damage on their enemies in a large area of effect then reappears on the other side of the targeted area.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Damage: 4 (2) \| Teleports to the other side | Damage: 5 (2) \| Teleports to the other side |
| Lv50 | Damage: 27 (2) \| Teleports to the other side | Damage: 34 (2) \| Teleports to the other side |
| Lv100 | Damage: 51 (2) \| Teleports to the other side | Damage: 64 (2) \| Teleports to the other side |
| Lv150 | Damage: 75 (2) \| Teleports to the other side | Damage: 94 (2) \| Teleports to the other side |
| Lv200 | Damage: 99 (2) \| Teleports to the other side | Damage: 124 (2) \| Teleports to the other side |
| Lv245 | Damage: 121 (2) \| Teleports to the other side | Damage: 151 (2) \| Teleports to the other side |

## Earth Elemental Spells

### 11. Rocky Foot

- Type: Earth elemental spell
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5033-rocky-foot
- Cost / Range: 3 AP, Range 1 - 3
- Cost progression: AP: 3; Range: 1 - 3
- Description: The Sacrier inflicts single-target damage and gains Armor. The Armor absorbs the next attacks received.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Damage: 3 \| 1 Armor | Damage: 3 \| 2 Armor |
| Lv50 | Damage: 20 \| 43 Armor | Damage: 25 \| 53 Armor |
| Lv100 | Damage: 38 \| 124 Armor | Damage: 48 \| 155 Armor |
| Lv150 | Damage: 56 \| 291 Armor | Damage: 70 \| 364 Armor |
| Lv200 | Damage: 74 \| 625 Armor | Damage: 93 \| 781 Armor |
| Lv245 | Damage: 90 \| 928 Armor | Damage: 113 \| 1,160 Armor |

### 12. Sacrier's Fist

- Type: Earth elemental spell
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5039-sacrier-fist
- Cost / Range: 2 AP, Range 1 - 4
- Cost progression: AP: 2; Range: 1 - 4
- Description: This spell moves the caster a few cells closer to their target.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Moves closer 3 cells \| Damage: 2 | Moves closer 3 cells \| Damage: 2 |
| Lv50 | Moves closer 3 cells \| Damage: 14 | Moves closer 3 cells \| Damage: 18 |
| Lv100 | Moves closer 3 cells \| Damage: 27 | Moves closer 3 cells \| Damage: 34 |
| Lv150 | Moves closer 3 cells \| Damage: 40 | Moves closer 3 cells \| Damage: 50 |
| Lv200 | Moves closer 3 cells \| Damage: 53 | Moves closer 3 cells \| Damage: 67 |
| Lv245 | Moves closer 3 cells \| Damage: 65 | Moves closer 3 cells \| Damage: 81 |

### 13. Insanity

- Type: Earth elemental spell
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5035-insanity
- Cost / Range: 2 AP, Range 1 - 3
- Cost progression: AP: 2; WP: 1; Range: 1 - 3
- Description: The Sacrier rages, increasing their Lock, attracting enemies and inflicting damage.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Attracts targets around the targeted cell \| Damage: 3 \| 0 Lock (1 turn) | Attracts targets around the targeted cell \| Damage: 3 \| 0 Lock (1 turn) |
| Lv50 | Attracts targets around the targeted cell \| Damage: 19 \| 24 Lock (1 turn) | Attracts targets around the targeted cell \| Damage: 23 \| 24 Lock (1 turn) |
| Lv100 | Attracts targets around the targeted cell \| Damage: 35 \| 49 Lock (1 turn) | Attracts targets around the targeted cell \| Damage: 44 \| 49 Lock (1 turn) |
| Lv150 | Attracts targets around the targeted cell \| Damage: 52 \| 74 Lock (1 turn) | Attracts targets around the targeted cell \| Damage: 65 \| 74 Lock (1 turn) |
| Lv200 | Attracts targets around the targeted cell \| Damage: 68 \| 99 Lock (1 turn) | Attracts targets around the targeted cell \| Damage: 85 \| 99 Lock (1 turn) |
| Lv245 | Attracts targets around the targeted cell \| Damage: 83 \| 122 Lock (1 turn) | Attracts targets around the targeted cell \| Damage: 104 \| 122 Lock (1 turn) |

### 14. Colonnades

- Type: Earth elemental spell
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5037-colonnades
- Cost / Range: 5 AP, Range 0 - 2
- Cost progression: AP: 5; Range: 0 - 2
- Description: The Sacrier smashes the ground with incredible force, making stone columns sprout up around the target. They inflict damage and generate Armor for each enemy hit; the Armor absorbs the next attacks received.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Damage: 5 \| Per hit: \| - 5 Armor | Damage: 6 \| Per hit: \| - 5 Armor |
| Lv50 | Damage: 36 \| Per hit: \| - 40 Armor | Damage: 46 \| Per hit: \| - 40 Armor |
| Lv100 | Damage: 69 \| Per hit: \| - 76 Armor \| - Armor: 5% of missing HP | Damage: 86 \| Per hit: \| - 76 Armor \| - Armor: 5% of missing HP |
| Lv150 | Damage: 101 \| Per hit: \| - 113 Armor \| - Armor: 5% of missing HP | Damage: 127 \| Per hit: \| - 113 Armor \| - Armor: 5% of missing HP |
| Lv200 | Damage: 134 \| Per hit: \| - 149 Armor \| - Armor: 5% of missing HP | Damage: 167 \| Per hit: \| - 149 Armor \| - Armor: 5% of missing HP |
| Lv245 | Damage: 163 \| Per hit: \| - 181 Armor \| - Armor: 5% of missing HP | Damage: 204 \| Per hit: \| - 181 Armor \| - Armor: 5% of missing HP |

### 15. Smashes

- Type: Earth elemental spell
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5036-smashes
- Cost / Range: 4 AP, Range 1 - 1
- Cost progression: AP: 4; Range: 1 - 1
- Description: Inflicts single-target damage and creates an Armor whose power depends on the Sacrier's missing HP. The Armor absorbs the next attacks received. The damage inflicted is greater if the target has Armor.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Damage: 4 \| If the target has Armor: \| - Damage: 6 instead \| Armor: 8% of missing HP | Damage: 5 \| If the target has Armor: \| - Damage: 7 instead \| Armor: 10% of missing HP |
| Lv50 | Damage: 27 \| If the target has Armor: \| - Damage: 41 instead \| Armor: 8% of missing HP | Damage: 34 \| If the target has Armor: \| - Damage: 51 instead \| Armor: 10% of missing HP |
| Lv100 | Damage: 51 \| If the target has Armor: \| - Damage: 77 instead \| Armor: 8% of missing HP | Damage: 64 \| If the target has Armor: \| - Damage: 96 instead \| Armor: 10% of missing HP |
| Lv150 | Damage: 75 \| If the target has Armor: \| - Damage: 113 instead \| Armor: 8% of missing HP | Damage: 94 \| If the target has Armor: \| - Damage: 141 instead \| Armor: 10% of missing HP |
| Lv200 | Damage: 99 \| If the target has Armor: \| - Damage: 149 instead \| Armor: 8% of missing HP | Damage: 124 \| If the target has Armor: \| - Damage: 186 instead \| Armor: 10% of missing HP |
| Lv245 | Damage: 121 \| If the target has Armor: \| - Damage: 181 instead \| Armor: 8% of missing HP | Damage: 151 \| If the target has Armor: \| - Damage: 227 instead \| Armor: 10% of missing HP |

## Active Specialties

### 16. Attraction

- Type: Active specialty
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5043-attraction
- Cost / Range: Range 2 - 7
- Cost progression: WP: 2; Range: 2 - 7
- Description: Attracts a target towards the Sacrier from far away.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Attracts by 6 cells | - |
| Lv50 | Attracts by 6 cells | - |
| Lv100 | Attracts by 6 cells | - |
| Lv150 | Attracts by 6 cells | - |
| Lv200 | Attracts by 6 cells | - |
| Lv245 | Attracts by 6 cells | - |

### 17. Sacrifice

- Type: Active specialty
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5045-sacrifice
- Cost / Range: 3 AP, Range 1 - 2
- Cost progression: AP: 3; Range: 1 - 2
- Description: With a gesture of self-sacrifice, the Sacrier takes blows on behalf of allies. Each time an ally suffers a spell that inflicts damage, the Sacrier suffers the damage, then switches places with the ally.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Sacrifice (2 turns) \| If the spell is cast on the Sacrier : \| - Sacrifice (2 turns) | - |
| Lv50 | Sacrifice (2 turns) \| If the spell is cast on the Sacrier : \| - Sacrifice (2 turns) | - |
| Lv100 | Sacrifice (2 turns) \| If the spell is cast on the Sacrier : \| - Sacrifice (2 turns) | - |
| Lv150 | Sacrifice (2 turns) \| If the spell is cast on the Sacrier : \| - Sacrifice (2 turns) | - |
| Lv200 | Sacrifice (2 turns) \| If the spell is cast on the Sacrier : \| - Sacrifice (2 turns) | - |
| Lv245 | Sacrifice (2 turns) \| If the spell is cast on the Sacrier : \| - Sacrifice (2 turns) | - |

### 18. Transposition

- Type: Active specialty
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5044-transposition
- Cost / Range: 1 AP, Range 2 - 6
- Cost progression: AP: 1; WP: 1; Range: 2 - 6
- Description: The Sacrier switches places with an ally or enemy.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Switches places | - |
| Lv50 | Switches places | - |
| Lv100 | Switches places | - |
| Lv150 | Switches places | - |
| Lv200 | Switches places | - |
| Lv245 | Switches places | - |

### 19. Sanguine Armor

- Type: Active specialty
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5047-sanguine-armor
- Cost / Range: 2 AP, Range 1 - 1
- Cost progression: AP: 2; Range: 1 - 1
- Description: The Sacrier creates, for themself or an ally, powerful Armor that absorbs damage up to a certain threshold. Also, for one turn, they increase Lock to keep enemies in close combat and stabilize them so they can't be moved.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Armor with 15% of the target's max HP \| Stabilized (1 turn) \| 0 Lock (1 turn) | - |
| Lv50 | Armor with 15% of the target's max HP \| Stabilized (1 turn) \| 98 Lock (1 turn) | - |
| Lv100 | Armor with 15% of the target's max HP \| Stabilized (1 turn) \| 198 Lock (1 turn) | - |
| Lv150 | Armor with 15% of the target's max HP \| Stabilized (1 turn) \| 298 Lock (1 turn) | - |
| Lv200 | Armor with 15% of the target's max HP \| Stabilized (1 turn) \| 398 Lock (1 turn) | - |
| Lv245 | Armor with 15% of the target's max HP \| Stabilized (1 turn) \| 488 Lock (1 turn) | - |

### 20. Gash

- Type: Active specialty
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/7211-gash
- Cost / Range: 1 AP, Range 1 - 6
- Cost progression: AP: 1; Range: 1 - 6
- Description: The Sacrier inflicts part of their life as damage on an ally (or themself) to increase the damage inflicted next turn. Gash can be very powerful when combined with Sacrifice to move.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Damage: 10% of HP current of caster \| 25% damage inflicted on next spell | - |
| Lv50 | Damage: 10% of HP current of caster \| 25% damage inflicted on next spell | - |
| Lv100 | Damage: 10% of HP current of caster \| 25% damage inflicted on next spell | - |
| Lv150 | Damage: 10% of HP current of caster \| 25% damage inflicted on next spell | - |
| Lv200 | Damage: 10% of HP current of caster \| 25% damage inflicted on next spell | - |
| Lv245 | Damage: 10% of HP current of caster \| 25% damage inflicted on next spell | - |

### 21. Blood Transfer

- Type: Active specialty
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/7212-blood-transfer
- Cost / Range: 1 AP, Range 1 - 4
- Cost progression: AP: 1; WP: 1; Range: 1 - 4
- Description: The Sacrier transfers some of their health to an ally and then switches places with them. If they target themself, some of their Armor is converted to healing.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | The Sacrier transfers 10% of their current HP to the targeted ally \| Switches places with the targeted ally \| If the spell is cast on the Sacrier : \| - Converts 50% of their Armor to healing | - |
| Lv50 | The Sacrier transfers 10% of their current HP to the targeted ally \| Switches places with the targeted ally \| If the spell is cast on the Sacrier : \| - Converts 50% of their Armor to healing | - |
| Lv100 | The Sacrier transfers 10% of their current HP to the targeted ally \| Switches places with the targeted ally \| If the spell is cast on the Sacrier : \| - Converts 50% of their Armor to healing | - |
| Lv150 | The Sacrier transfers 10% of their current HP to the targeted ally \| Switches places with the targeted ally \| If the spell is cast on the Sacrier : \| - Converts 50% of their Armor to healing | - |
| Lv200 | The Sacrier transfers 10% of their current HP to the targeted ally \| Switches places with the targeted ally \| If the spell is cast on the Sacrier : \| - Converts 50% of their Armor to healing | - |
| Lv245 | The Sacrier transfers 10% of their current HP to the targeted ally \| Switches places with the targeted ally \| If the spell is cast on the Sacrier : \| - Converts 50% of their Armor to healing | - |

## Passives

### 22. Blood Flow

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/7213-blood-flow
- Cost / Range: -
- Cost progression: -
- Description: The Sacrier's healing is significantly less reduced by resistance to healing, but the armor the Sacrier receives is reduced.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | When the Sacrier heals themself, the impact of Healing Resistance is halved \| -50% Armor received | - |
| Lv50 | When the Sacrier heals themself, the impact of Healing Resistance is halved \| -50% Armor received | - |
| Lv100 | When the Sacrier heals themself, the impact of Healing Resistance is halved \| -50% Armor received | - |
| Lv150 | When the Sacrier heals themself, the impact of Healing Resistance is halved \| -50% Armor received | - |
| Lv200 | When the Sacrier heals themself, the impact of Healing Resistance is halved \| -50% Armor received | - |
| Lv245 | When the Sacrier heals themself, the impact of Healing Resistance is halved \| -50% Armor received | - |

### 23. Burning

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/7224-burning
- Cost / Range: -
- Cost progression: -
- Description: The Sacrier catches fire if they end their turn adjacent to an enemy. If no enemies are adjacent to the Sacrier when they start a turn, the Sacrier suffers a flame return equivalent to Flaming.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | At end of turn, if an enemy is adjacent to the Sacrier: \| - 100% of level as Flaming \| If no enemies are adjacent to the Sacrier at the start of the turn: \| Flame Return : receives the Flaming effect | - |
| Lv50 | At end of turn, if an enemy is adjacent to the Sacrier: \| - 100% of level as Flaming \| If no enemies are adjacent to the Sacrier at the start of the turn: \| Flame Return : receives the Flaming effect | - |
| Lv100 | At end of turn, if an enemy is adjacent to the Sacrier: \| - 100% of level as Flaming \| If no enemies are adjacent to the Sacrier at the start of the turn: \| Flame Return : receives the Flaming effect | - |
| Lv150 | At end of turn, if an enemy is adjacent to the Sacrier: \| - 100% of level as Flaming \| If no enemies are adjacent to the Sacrier at the start of the turn: \| Flame Return : receives the Flaming effect | - |
| Lv200 | At end of turn, if an enemy is adjacent to the Sacrier: \| - 100% of level as Flaming \| If no enemies are adjacent to the Sacrier at the start of the turn: \| Flame Return : receives the Flaming effect | - |
| Lv245 | At end of turn, if an enemy is adjacent to the Sacrier: \| - 100% of level as Flaming \| If no enemies are adjacent to the Sacrier at the start of the turn: \| Flame Return : receives the Flaming effect | - |

### 24. Pillar

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/7220-pillar
- Cost / Range: -
- Cost progression: -
- Description: Makes the Sacrier less mobile but grants HP regeneration capabilities and a resistance bonus when the Sacrier is adjacent to their enemies.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | At end of turn, per adjacent enemy: \| - Healing: 10% of HP lost of the caster \| - 30 Elemental Resistance (1 turn) \| - -1 max MP (1 turn) | - |
| Lv50 | At end of turn, per adjacent enemy: \| - Healing: 10% of HP lost of the caster \| - 30 Elemental Resistance (1 turn) \| - -1 max MP (1 turn) | - |
| Lv100 | At end of turn, per adjacent enemy: \| - Healing: 10% of HP lost of the caster \| - 30 Elemental Resistance (1 turn) \| - -1 max MP (1 turn) | - |
| Lv150 | At end of turn, per adjacent enemy: \| - Healing: 10% of HP lost of the caster \| - 30 Elemental Resistance (1 turn) \| - -1 max MP (1 turn) | - |
| Lv200 | At end of turn, per adjacent enemy: \| - Healing: 10% of HP lost of the caster \| - 30 Elemental Resistance (1 turn) \| - -1 max MP (1 turn) | - |
| Lv245 | At end of turn, per adjacent enemy: \| - Healing: 10% of HP lost of the caster \| - 30 Elemental Resistance (1 turn) \| - -1 max MP (1 turn) | - |

### 25. Motion Sick

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/7219-motion-sick
- Cost / Range: -
- Cost progression: -
- Description: Targets moved by the Sacrier lose MP. If the Sacrier uses a spell to move themself, they also lose MP.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | If a fighter is moved by the Sacrier: \| -2 MP (1 turn, not stackable) | - |
| Lv50 | If a fighter is moved by the Sacrier: \| -2 MP (1 turn, not stackable) | - |
| Lv100 | If a fighter is moved by the Sacrier: \| -2 MP (1 turn, not stackable) | - |
| Lv150 | If a fighter is moved by the Sacrier: \| -2 MP (1 turn, not stackable) | - |
| Lv200 | If a fighter is moved by the Sacrier: \| -2 MP (1 turn, not stackable) | - |
| Lv245 | If a fighter is moved by the Sacrier: \| -2 MP (1 turn, not stackable) | - |

### 26. Sacrier's Heart

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/7218-sacrier-heart
- Cost / Range: -
- Cost progression: -
- Description: Under the influence of Bold Punishment, the Sacrier's melee mastery and distance mastery are added together to increase their damage and versatility, in exchange for their range.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | In Bold Punishment : \| - Melee Mastery is added to Distance Mastery \| - Distance Mastery is added to Melee Mastery \| -2 Range | - |
| Lv50 | In Bold Punishment : \| - Melee Mastery is added to Distance Mastery \| - Distance Mastery is added to Melee Mastery \| -2 Range | - |
| Lv100 | In Bold Punishment : \| - Melee Mastery is added to Distance Mastery \| - Distance Mastery is added to Melee Mastery \| -2 Range | - |
| Lv150 | In Bold Punishment : \| - Melee Mastery is added to Distance Mastery \| - Distance Mastery is added to Melee Mastery \| -2 Range | - |
| Lv200 | In Bold Punishment : \| - Melee Mastery is added to Distance Mastery \| - Distance Mastery is added to Melee Mastery \| -2 Range | - |
| Lv245 | In Bold Punishment : \| - Melee Mastery is added to Distance Mastery \| - Distance Mastery is added to Melee Mastery \| -2 Range | - |

### 27. Wakfu Pact

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/7217-wakfu-pact
- Cost / Range: -
- Cost progression: -
- Description: The Sacrier gains HP but suffers a flame return each time they use WP.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | HP bonus for the Sacrier: \| - 400% of their level (+0) \| For each WP used: \| - Flame Return : 5% of current HP | - |
| Lv50 | HP bonus for the Sacrier: \| - 400% of their level (+0) \| For each WP used: \| - Flame Return : 5% of current HP | - |
| Lv100 | HP bonus for the Sacrier: \| - 400% of their level (+0) \| For each WP used: \| - Flame Return : 5% of current HP | - |
| Lv150 | HP bonus for the Sacrier: \| - 400% of their level (+0) \| For each WP used: \| - Flame Return : 5% of current HP | - |
| Lv200 | HP bonus for the Sacrier: \| - 400% of their level (+0) \| For each WP used: \| - Flame Return : 5% of current HP | - |
| Lv245 | HP bonus for the Sacrier: \| - 400% of their level (+0) \| For each WP used: \| - Flame Return : 5% of current HP | - |

### 28. Burning Armor

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/7216-burning-armor
- Cost / Range: -
- Cost progression: -
- Description: The Sacrier turns their flame returns into Armor. However, if they have Armor left when their turn starts, they suffer it as damage.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Flame Returns turn into Armor \| At start of turn, the Sacrier suffers remaining Armor as damage | - |
| Lv50 | Flame Returns turn into Armor \| At start of turn, the Sacrier suffers remaining Armor as damage | - |
| Lv100 | Flame Returns turn into Armor \| At start of turn, the Sacrier suffers remaining Armor as damage | - |
| Lv150 | Flame Returns turn into Armor \| At start of turn, the Sacrier suffers remaining Armor as damage | - |
| Lv200 | Flame Returns turn into Armor \| At start of turn, the Sacrier suffers remaining Armor as damage | - |
| Lv245 | Flame Returns turn into Armor \| At start of turn, the Sacrier suffers remaining Armor as damage | - |

### 29. Vision

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/7215-vision
- Cost / Range: -
- Cost progression: -
- Description: This passive increases the range of the Sacrier's movement spells. In exchange, Armor gains are reduced by half if the Sacrier is not adjacent to another fighter.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | 1 Range to movement spells \| If there are no fighters adjacent to the Sacrier: \| - Armor gains are reduced by half | - |
| Lv50 | 1 Range to movement spells \| If there are no fighters adjacent to the Sacrier: \| - Armor gains are reduced by half | - |
| Lv100 | 1 Range to movement spells \| If there are no fighters adjacent to the Sacrier: \| - Armor gains are reduced by half | - |
| Lv150 | 1 Range to movement spells \| If there are no fighters adjacent to the Sacrier: \| - Armor gains are reduced by half | - |
| Lv200 | 1 Range to movement spells \| If there are no fighters adjacent to the Sacrier: \| - Armor gains are reduced by half | - |
| Lv245 | 1 Range to movement spells \| If there are no fighters adjacent to the Sacrier: \| - Armor gains are reduced by half | - |

### 30. Dangerous Game

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/7214-dangerous-game
- Cost / Range: -
- Cost progression: -
- Description: This passive makes it much easier for the Sacrier to get out of a sticky situation when their HP is very low. However, they are harder to heal when their current HP are high.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | If current HP < 35%: \| - 100% Heals received \| If current HP >= 35%: \| -75% Heals received | - |
| Lv50 | If current HP < 35%: \| - 100% Heals received \| If current HP >= 35%: \| -75% Heals received | - |
| Lv100 | If current HP < 35%: \| - 100% Heals received \| If current HP >= 35%: \| -75% Heals received | - |
| Lv150 | If current HP < 35%: \| - 100% Heals received \| If current HP >= 35%: \| -75% Heals received | - |
| Lv200 | If current HP < 35%: \| - 100% Heals received \| If current HP >= 35%: \| -75% Heals received | - |
| Lv245 | If current HP < 35%: \| - 100% Heals received \| If current HP >= 35%: \| -75% Heals received | - |

### 31. Blood Trail

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5049-blood-trail
- Cost / Range: -
- Cost progression: -
- Description: The Sacrier boosts their Lock and Dodge each time they inflict a flame return on themself. However, the flame returns are greater.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | When the Sacrier inflicts a Flame Return on themself: \| - 100% of level as Lock (1 turn, stackable) \| - 100% of level as Dodge (1 turn, stackable) \| Flame Returns are increased by 20% | - |
| Lv50 | When the Sacrier inflicts a Flame Return on themself: \| - 100% of level as Lock (1 turn, stackable) \| - 100% of level as Dodge (1 turn, stackable) \| Flame Returns are increased by 20% | - |
| Lv100 | When the Sacrier inflicts a Flame Return on themself: \| - 100% of level as Lock (1 turn, stackable) \| - 100% of level as Dodge (1 turn, stackable) \| Flame Returns are increased by 20% | - |
| Lv150 | When the Sacrier inflicts a Flame Return on themself: \| - 100% of level as Lock (1 turn, stackable) \| - 100% of level as Dodge (1 turn, stackable) \| Flame Returns are increased by 20% | - |
| Lv200 | When the Sacrier inflicts a Flame Return on themself: \| - 100% of level as Lock (1 turn, stackable) \| - 100% of level as Dodge (1 turn, stackable) \| Flame Returns are increased by 20% | - |
| Lv245 | When the Sacrier inflicts a Flame Return on themself: \| - 100% of level as Lock (1 turn, stackable) \| - 100% of level as Dodge (1 turn, stackable) \| Flame Returns are increased by 20% | - |

### 32. Clinging to Life

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5052-clinging-life
- Cost / Range: -
- Cost progression: -
- Description: When the Sacrier is mortally wounded, they gain resistance and a large amount of Armor. However, they won't be able to go above 20% max HP for a full turn.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | After falling below 20% max HP: \| - 20% of max HP as Armor \| - Impending Death | - |
| Lv50 | After falling below 20% max HP: \| - 20% of max HP as Armor \| - Impending Death | - |
| Lv100 | After falling below 20% max HP: \| - 20% of max HP as Armor \| - Impending Death | - |
| Lv150 | After falling below 20% max HP: \| - 20% of max HP as Armor \| - Impending Death | - |
| Lv200 | After falling below 20% max HP: \| - 20% of max HP as Armor \| - Impending Death | - |
| Lv245 | After falling below 20% max HP: \| - 20% of max HP as Armor \| - Impending Death | - |

### 33. Smasher

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5195-smasher
- Cost / Range: -
- Cost progression: -
- Description: This passive gives the Sacrier more control over their HP. When the Sacrier inflicts damage on a target, they steal some if the target's % of HP is higher than the Sacrier's. If the Sacrier's % of HP is higher than their target's, the Sacrier inflicts a flame return on themself.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | If the target has more %HP than the Sacrier: \| - 25% health stolen \| Otherwise: \| - Flame Return : 15% of damage inflicted | - |
| Lv50 | If the target has more %HP than the Sacrier: \| - 25% health stolen \| Otherwise: \| - Flame Return : 15% of damage inflicted | - |
| Lv100 | If the target has more %HP than the Sacrier: \| - 25% health stolen \| Otherwise: \| - Flame Return : 15% of damage inflicted | - |
| Lv150 | If the target has more %HP than the Sacrier: \| - 25% health stolen \| Otherwise: \| - Flame Return : 15% of damage inflicted | - |
| Lv200 | If the target has more %HP than the Sacrier: \| - 25% health stolen \| Otherwise: \| - Flame Return : 15% of damage inflicted | - |
| Lv245 | If the target has more %HP than the Sacrier: \| - 25% health stolen \| Otherwise: \| - Flame Return : 15% of damage inflicted | - |

### 34. Mobility

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5192-mobility
- Cost / Range: -
- Cost progression: -
- Description: The Sacrier can move their targets and themself more easily, but it costs their ability to keep opponents next to them.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | For each movement spell (up to 3 times): \| - 1 max MP (1 turn) \| - 100% of level as Dodge (1 turn) \| At start of combat, Lock is reduced to 0 | - |
| Lv50 | For each movement spell (up to 3 times): \| - 1 max MP (1 turn) \| - 100% of level as Dodge (1 turn) \| At start of combat, Lock is reduced to 0 | - |
| Lv100 | For each movement spell (up to 3 times): \| - 1 max MP (1 turn) \| - 100% of level as Dodge (1 turn) \| At start of combat, Lock is reduced to 0 | - |
| Lv150 | For each movement spell (up to 3 times): \| - 1 max MP (1 turn) \| - 100% of level as Dodge (1 turn) \| At start of combat, Lock is reduced to 0 | - |
| Lv200 | For each movement spell (up to 3 times): \| - 1 max MP (1 turn) \| - 100% of level as Dodge (1 turn) \| At start of combat, Lock is reduced to 0 | - |
| Lv245 | For each movement spell (up to 3 times): \| - 1 max MP (1 turn) \| - 100% of level as Dodge (1 turn) \| At start of combat, Lock is reduced to 0 | - |

### 35. Transcendence

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5054-transcendence
- Cost / Range: -
- Cost progression: -
- Description: In exchange for one WP, the Sacrier can greatly increase their Dodge or Lock using their punishments.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Bold Punishment : \| - Adds Melee Mastery to Dodge \| Bloodthirsty Punishment : \| - Adds Melee Mastery to Lock \| Punishments cost 1 extra WP | - |
| Lv50 | Bold Punishment : \| - Adds Melee Mastery to Dodge \| Bloodthirsty Punishment : \| - Adds Melee Mastery to Lock \| Punishments cost 1 extra WP | - |
| Lv100 | Bold Punishment : \| - Adds Melee Mastery to Dodge \| Bloodthirsty Punishment : \| - Adds Melee Mastery to Lock \| Punishments cost 1 extra WP | - |
| Lv150 | Bold Punishment : \| - Adds Melee Mastery to Dodge \| Bloodthirsty Punishment : \| - Adds Melee Mastery to Lock \| Punishments cost 1 extra WP | - |
| Lv200 | Bold Punishment : \| - Adds Melee Mastery to Dodge \| Bloodthirsty Punishment : \| - Adds Melee Mastery to Lock \| Punishments cost 1 extra WP | - |
| Lv245 | Bold Punishment : \| - Adds Melee Mastery to Dodge \| Bloodthirsty Punishment : \| - Adds Melee Mastery to Lock \| Punishments cost 1 extra WP | - |

### 36. Libation

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5193-libation
- Cost / Range: -
- Cost progression: -
- Description: The Sacrier loses their natural WP regeneration. However, they gain it by inflicting Flame Returns on themself.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Every 4 Flame Returns: \| - 2 WP \| Natural WP regeneration is disabled | - |
| Lv50 | Every 4 Flame Returns: \| - 2 WP \| Natural WP regeneration is disabled | - |
| Lv100 | Every 4 Flame Returns: \| - 2 WP \| Natural WP regeneration is disabled | - |
| Lv150 | Every 4 Flame Returns: \| - 2 WP \| Natural WP regeneration is disabled | - |
| Lv200 | Every 4 Flame Returns: \| - 2 WP \| Natural WP regeneration is disabled | - |
| Lv245 | Every 4 Flame Returns: \| - 2 WP \| Natural WP regeneration is disabled | - |

### 37. Blood Pact

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5053-blood-pact
- Cost / Range: -
- Cost progression: -
- Description: The Sacrier's max HP is reduced, but they gain Armor if they drop below 20% max HP and then if they go above 40% max HP afterward.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | After falling below 20% max HP (1 time per turn): \| - 10% of max HP as Armor \| - 1 WP \| After going above 40% max HP (1 time per turn): \| - 10% of max HP as Armor \| - 1 WP \| -30% Health Points | - |
| Lv50 | After falling below 20% max HP (1 time per turn): \| - 10% of max HP as Armor \| - 1 WP \| After going above 40% max HP (1 time per turn): \| - 10% of max HP as Armor \| - 1 WP \| -30% Health Points | - |
| Lv100 | After falling below 20% max HP (1 time per turn): \| - 10% of max HP as Armor \| - 1 WP \| After going above 40% max HP (1 time per turn): \| - 10% of max HP as Armor \| - 1 WP \| -30% Health Points | - |
| Lv150 | After falling below 20% max HP (1 time per turn): \| - 10% of max HP as Armor \| - 1 WP \| After going above 40% max HP (1 time per turn): \| - 10% of max HP as Armor \| - 1 WP \| -30% Health Points | - |
| Lv200 | After falling below 20% max HP (1 time per turn): \| - 10% of max HP as Armor \| - 1 WP \| After going above 40% max HP (1 time per turn): \| - 10% of max HP as Armor \| - 1 WP \| -30% Health Points | - |
| Lv245 | After falling below 20% max HP (1 time per turn): \| - 10% of max HP as Armor \| - 1 WP \| After going above 40% max HP (1 time per turn): \| - 10% of max HP as Armor \| - 1 WP \| -30% Health Points | - |

### 38. Placidity

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5050-placidity
- Cost / Range: -
- Cost progression: -
- Description: As long as the Sacrier hasn't used MP to move, they heal themself using movement spells.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | For each movement spell, as long as the Sacrier has not used MP to move: \| - Healing: 5% of missing HP for each movement spell \| -2 max WP | - |
| Lv50 | For each movement spell, as long as the Sacrier has not used MP to move: \| - Healing: 5% of missing HP for each movement spell \| -2 max WP | - |
| Lv100 | For each movement spell, as long as the Sacrier has not used MP to move: \| - Healing: 5% of missing HP for each movement spell \| -2 max WP | - |
| Lv150 | For each movement spell, as long as the Sacrier has not used MP to move: \| - Healing: 5% of missing HP for each movement spell \| -2 max WP | - |
| Lv200 | For each movement spell, as long as the Sacrier has not used MP to move: \| - Healing: 5% of missing HP for each movement spell \| -2 max WP | - |
| Lv245 | For each movement spell, as long as the Sacrier has not used MP to move: \| - Healing: 5% of missing HP for each movement spell \| -2 max WP | - |

### 39. Wakfu Veins

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5194-wakfu-veins
- Cost / Range: -
- Cost progression: -
- Description: The Sacrier replaces the WP cost of their movement spells with an AP cost. If the Sacrier uses a spell to move an enemy, the enemy will suffer direct damage. However, if the Sacrier uses a spell to move themself, they suffer a flame return.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | Movement spells cost 1 less WP but 1 more AP \| When moving an enemy with a spell: \| - damage: 1 (direct damage) \| When moving with a spell: \| - Flame Return : 5% of current HP | - |
| Lv50 | Movement spells cost 1 less WP but 1 more AP \| When moving an enemy with a spell: \| - damage: 1 (direct damage) \| When moving with a spell: \| - Flame Return : 5% of current HP | - |
| Lv100 | Movement spells cost 1 less WP but 1 more AP \| When moving an enemy with a spell: \| - damage: 1 (direct damage) \| When moving with a spell: \| - Flame Return : 5% of current HP | - |
| Lv150 | Movement spells cost 1 less WP but 1 more AP \| When moving an enemy with a spell: \| - damage: 1 (direct damage) \| When moving with a spell: \| - Flame Return : 5% of current HP | - |
| Lv200 | Movement spells cost 1 less WP but 1 more AP \| When moving an enemy with a spell: \| - damage: 1 (direct damage) \| When moving with a spell: \| - Flame Return : 5% of current HP | - |
| Lv245 | Movement spells cost 1 less WP but 1 more AP \| When moving an enemy with a spell: \| - damage: 1 (direct damage) \| When moving with a spell: \| - Flame Return : 5% of current HP | - |

### 40. Tattooed Blood

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/5051-tattooed-blood
- Cost / Range: -
- Cost progression: -
- Description: The Sacrier gains HP but loses Range, focusing on melee combat.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | HP bonus for the Sacrier: \| - 800% of their level (+0) \| -2 Range to their movement spells | - |
| Lv50 | HP bonus for the Sacrier: \| - 800% of their level (+0) \| -2 Range to their movement spells | - |
| Lv100 | HP bonus for the Sacrier: \| - 800% of their level (+0) \| -2 Range to their movement spells | - |
| Lv150 | HP bonus for the Sacrier: \| - 800% of their level (+0) \| -2 Range to their movement spells | - |
| Lv200 | HP bonus for the Sacrier: \| - 800% of their level (+0) \| -2 Range to their movement spells | - |
| Lv245 | HP bonus for the Sacrier: \| - 800% of their level (+0) \| -2 Range to their movement spells | - |

### 41. Executor

- Type: Passive
- Source: https://www.wakfu.com/en/mmorpg/encyclopedia/classes/11-sacrier/7830-executor
- Cost / Range: -
- Cost progression: -
- Description: This passive increases the range of the Sacrier's movement spells. In exchange, healing received is reduced by half if the Sacrier is adjacent to another fighter.

| Level | Normal effects | Critical effects |
|---|---|---|
| Lv1 | 1 Range to movement spells \| If the Sacrier is adjacent to a fighter: \| - Healing is reduced by half | - |
| Lv50 | 1 Range to movement spells \| If the Sacrier is adjacent to a fighter: \| - Healing is reduced by half | - |
| Lv100 | 1 Range to movement spells \| If the Sacrier is adjacent to a fighter: \| - Healing is reduced by half | - |
| Lv150 | 1 Range to movement spells \| If the Sacrier is adjacent to a fighter: \| - Healing is reduced by half | - |
| Lv200 | 1 Range to movement spells \| If the Sacrier is adjacent to a fighter: \| - Healing is reduced by half | - |
| Lv245 | 1 Range to movement spells \| If the Sacrier is adjacent to a fighter: \| - Healing is reduced by half | - |

