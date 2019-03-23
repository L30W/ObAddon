----------------------------------------------------------------
--  MODULE: Harder Enemy Placement
----------------------------------------------------------------
--
--  Copyright (C) 2019 Glaice
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------

HARDER_ENEMY = { }

HARDER_ENEMY.MONSTERS =
{

  zombie =
  {
    id = 3004
    r = 20
    h = 56
    level = 1
    prob = 50
    health = 20
    damage = 1.2
    attack = "hitscan"
    replaces = "shooter"
    replace_prob = 25
    give = { {ammo="bullet",count=5} }
    density = 1.5
    room_size = "any" --small
    disloyal = true
    trap_factor = 0.01
    infight_damage = 1.9
  }

  shooter =
  {
    id = 9
    r = 20
    h = 56
    level = 1
    prob = 90
    health = 30
    damage = 3.0
    attack = "hitscan"
    density = 1.0
    give = { {weapon="shotty"}, {ammo="shell",count=4} }
    weap_prefs = { shotty=1.2, chain=1.3 }
    weap_needed = { shotty=true }
    species = "zombie"
    replaces = "zombie"
    replace_prob = 30
    room_size = "any" --small
    disloyal = true
    trap_factor = 2.2 --2.0
    infight_damage = 6.1
  }

  imp =
  {
    id = 3001
    r = 20
    h = 56
    level = 1
    prob = 140
    health = 60
    damage = 1.3
    attack = "missile"
    density = 1.0
    replaces = "demon"
    replace_prob = 30
    weap_prefs = { shotty=3.0, chain=2.0, super=1.5 }
    room_size = "any" --small
    trap_factor = 0.5 --0.3
    infight_damage = 4.0
  }

  skull =
  {
    id = 3006
    r = 16
    h = 56
    level = 3
    prob = 25
    health = 100
    damage = 1.7
    attack = "melee"
    density = 0.5
    float = true
    weap_prefs = { super=2.0, shotty=1.5, chain=1.3 }
    room_size = "any" --small
    disloyal = true
    trap_factor = 0.35 --0.2
    cage_factor = 0
    infight_damage = 2.1
  }

  demon =
  {
    id = 3002
    r = 30
    h = 56
    level = 1.4 --2
    prob = 50
    health = 150
    damage = 0.4
    attack = "melee"
    density = 0.85
    weap_min_damage = 40
    weap_prefs = { super=3.0, shotty=1.5, chain=1.4 }
    room_size = "any"
    infight_damage = 3.5
  }

  spectre =
  {
    id = 58
    r = 30
    h = 56
    level = 1.4 --2.8
    replaces = "demon"
    replace_prob = 35
    crazy_prob = 25
    health = 150
    damage = 1.0
    attack = "melee"
    density = 0.5
    invis = true
    outdoor_factor = 3.0
    weap_min_damage = 40
    weap_prefs = { super=3.0, shotty=1.5, chain=1.4 }
    species = "demon"
    room_size = "any"
    trap_factor = 0.3
    infight_damage = 2.5
  }

  caco =
  {
    id = 3005
    r = 31
    h = 56
    level = 3
    prob = 30
    health = 400
    damage = 4.0
    attack = "missile"
    density = 0.6
    weap_min_damage = 40
    float = true
    weap_prefs = { launch=2.0, super=3.0, chain=1.2, shotty=0.7 }
    replaces = "pain"
    replace_prob = 20
    room_size = "any" --large
    trap_factor = 0.5
    infight_damage = 21
  }


  ---| BOSSES |---

  baron =
  {
    id = 3003
    r = 24
    h = 64
    level = 5
    boss_type = "minor"
    boss_prob = 50
    prob = 6.4
    crazy_prob = 20
    weap_prefs = { launch=3.0, super=2.0, plasma=3.0, bfg=1.5 }
    health = 1000
    damage = 7.5
    attack = "missile"
    density = 0.3
    weap_min_damage = 88
    room_size = "any" --medium
    infight_damage = 40
  }

  Cyberdemon =
  {
    id = 16
    r = 40
    h = 110
    level = 6 --8
    boss_type = "tough"
    boss_prob = 50
    prob = 1.6
    crazy_prob = 10
    health = 4000
    damage = 125
    attack = "missile"
    density = 0.1
    weap_min_damage = 150
    weap_prefs = { bfg=10.0 }
    room_size = "large" --medium
    infight_damage = 1600
    cage_factor = 0
    boss_replacement = "baron"
  }

  Spiderdemon =
  {
    id = 7
    r = 128
    h = 100
    level = 6
    boss_type = "tough"
    boss_prob = 15
    boss_limit = 1 -- because they infight
    prob = 2.0
    crazy_prob = 10
    health = 3000
    damage = 100
    attack = "hitscan"
    density = 0.1
    cage_factor = 0
    weap_min_damage = 200
    weap_prefs = { bfg=10.0 }
    room_size = "large"
    infight_damage = 700
    boss_replacement = "Cyberdemon"
  }


  ---== Doom II only ==---

  gunner =
  {
    id = 65
    r = 20
    h = 56
    level = 1.5 --2
    prob = 60
    health = 70
    damage = 5.5
    attack = "hitscan"
    give = { {weapon="chain"}, {ammo="bullet",count=10} }
    weap_needed = { chain=true }
    weap_min_damage = 50
    weap_prefs = { shotty=1.5, super=2.0, chain=2.0, plasma=1.2, launch=1.1 }
    density = 0.75
    species = "zombie"
    room_size = "any" --large
    replaces = "shooter"
    replace_prob = 30
    disloyal = true
    trap_factor = 2.4
    infight_damage = 25
  }

  revenant =
  {
    id = 66
    r = 20
    h = 64
    level = 3.5
    prob = 25
    health = 300
    damage = 9 --8.5
    attack = "missile"
    weap_min_damage = 60
    density = 0.6
    weap_prefs = { launch=3.0, plasma=2.5, super=2.0 }
    room_size = "any"
    replaces = "knight"
    replace_prob = 15
    trap_factor = 3.6
    infight_damage = 20
  }

  knight =
  {
    id = 69
    r = 24
    h = 64
    level = 4
    prob = 26
    health = 500
    damage = 4.0
    attack = "missile"
    weap_min_damage = 50
    weap_prefs = { launch=3.0, super=2.5, plasma=1.5 }
    density = 0.75
    species = "baron"
    replaces = "mancubus"
    replace_prob = 25
    room_size = "any" --medium
    infight_damage = 36
  }

  mancubus =
  {
    id = 67
    r = 48
    h = 64
    level = 4.5
    prob = 20
    health = 600
    damage = 8.0
    attack = "missile"
    weap_prefs = { launch=3.0, super=2.0, plasma=2.0, chain=1.2 }
    density = 0.32
    weap_min_damage = 88
    replaces = "arach"
    replace_prob = 30
    room_size = "large"
    outdoor_factor = 2.0
    infight_damage = 70
    boss_replacement = "baron"
  }

  arach =
  {
    id = 68
    r = 64
    h = 64
    level = 4.5
    prob = 12
    health = 500
    damage = 10.7
    attack = "missile"
    weap_min_damage = 60
    weap_prefs = { launch=3.0, super=2.0, plasma=2.0, chain=1.2 }
    replaces = "mancubus"
    replace_prob = 30
    density = 0.5
    room_size = "medium"
    infight_damage = 62
    boss_replacement = "revenant"
  }

  vile =
  {
    id = 64
    r = 20
    h = 56
    level = 6 --6.5
    boss_type = "nasty"
    boss_prob = 50
    boss_limit = 3 --Triple the pain for this module, up from 2
    prob = 5
    crazy_prob = 15
    health = 700
    damage = 25
    attack = "hitscan"
    density = 0.17
    room_size = "medium"
    weap_prefs = { launch=2.0, super=3.0, plasma=2.0, bfg=1.5 }
    weap_min_damage = 120
    nasty = true
    infight_damage = 18
    boss_replacement = "baron"
  }

  pain =
  {
    id = 71
    r = 31
    h = 56
    level = 4
    boss_type = "nasty"
    boss_prob = 15
    boss_limit = 4 --Increases the pain, up from 3. hue hue
    prob = 10
    crazy_prob = 15
    health = 900  -- 400 + 5 skulls
    damage = 14.5 -- about 5 skulls
    attack = "missile"
    density = 0.2
    float = true
    weap_min_damage = 100
    weap_prefs = { launch=2.0, super=3.0, chain=1.2, shotty=0.7 }
    room_size = "any" --large
    cage_factor = 0  -- never put in cages
    infight_damage = 4.5 -- guess
  }

  -- NOTE: this is not normally added to levels
  ss_nazi =
  {
    id = 84
    r = 20
    h = 56
    level = 1
    prob  = 0
    crazy_prob = 0
    health = 50
    damage = 2.8
    attack = "hitscan"
    give = { {ammo="bullet",count=5} }
    density = 1.5
    infight_damage = 6.0
  }
}


function HARDER_ENEMY.setup(self)
  if not PARAM.doom2_weapons then
    GAME.MONSTERS["gunner"] = nil
    GAME.MONSTERS["knight"] = nil
    GAME.MONSTERS["revenant"] = nil
    GAME.MONSTERS["mancubus"] = nil
    GAME.MONSTERS["arach"] = nil
    GAME.MONSTERS["vile"] = nil
    GAME.MONSTERS["pain"] = nil
    GAME.MONSTERS["ss_nazi"] = nil
  end

  for name,_ in pairs(HARDER_ENEMY.MONSTERS) do
    local M = GAME.MONSTERS[name]

    if M and factor then
      M.prob = M.prob * factor
      M.crazy_prob = (M.crazy_prob or M.prob) * factor
    end
  end
end


OB_MODULES["harder_enemy"] =
{
  label = _("Harder Enemy Setup")

  side = "left"
  game = "doomish"

  tooltip = "Changes enemy placement and thus makes overall gameplay a bit to fair bit harder, depending if you use additional mods in the case of GZDoom."

  engine = { zdoom=1, gzdoom=1, skulltag=1, limit=1 }

  tables =
  {
    HARDER_ENEMY
  }

  hooks =
  {
    setup = HARDER_ENEMY.setup
  }
}
