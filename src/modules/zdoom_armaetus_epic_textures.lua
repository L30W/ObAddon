------------------------------------------------------------------------
--  MODULE: Armaetus Texture Pack Mod
------------------------------------------------------------------------
--
--  Copyright (C) 2019 Armaetus
--  Copyright (C) 2019 MsrSgtShooterPerson
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
-------------------------------------------------------------------

-- Armaetus: I'm not renaming all these functions. If you wanna do it MSSP,
-- you are free to do it lol. Remove these lines when that is done, if done.
gui.import("zdoom_armaetus_materials.lua")
gui.import("zdoom_armaetus_themes.lua")

gui.import("zdoom_armaetus_doom1_materials.lua")
gui.import("zdoom_armaetus_doom1_themes.lua")

ARMAETUS_EPIC_TEXTURES = { }

ARMAETUS_EPIC_TEXTURES.YES_NO =
{
  "yes", _("Yes"),
  "no",  _("No"),
}

ARMAETUS_EPIC_TEXTURES.SOUCEPORT_CHOICES =
{
  "zs",       _("ZScript"),
  "decorate", _("ACS-Decorate"),
  "no",       _("No"),
}

ARMAETUS_EPIC_TEXTURES.ENVIRONMENT_THEME_CHOICES =
{
  "random",    _("Random"),
  "mixed",     _("A Bit Mixed"),
  "snowish",   _("Snow-ish"),
  "desertish", _("Desert-ish"),
  "snow",      _("Always Snow"),
  "desert",    _("Always Desert"),
  "no",        _("No"),
}

function ARMAETUS_EPIC_TEXTURES.setup(self)
  for name,opt in pairs(self.options) do
    local value = self.options[name].value
    PARAM[name] = value
  end

  ARMAETUS_EPIC_TEXTURES.put_new_materials()
  PARAM.epic_textures_activated = true
end

function ARMAETUS_EPIC_TEXTURES.decide_environment_themes()
  --------------------
  -- Outdoor Themes --
  --------------------
  -- Outdoor themes are essentially 'mutator' style inserts
  -- to replace the flats of outdoor rooms to match a specific
  -- theme - particularly snow and sand. Currently, there are three
  -- themes:
  --
  -- 1) Snow - emphasis on cold and snow, white textures.
  -- 2) Desert - emphasis on bright sand.
  -- 3) Temperate - technically not actually a theme, but a catch-all
  --                for the default circumstances of using ordinary
  --                grass, rock, etc. in temperate regions as is the
  --                norm for vanilla Doom-ish games.
  --
  -- Essentially, when "Temperate" is the selected theme, the
  -- environment theme code simply just doesn't run.

  if PARAM.environment_themes == "no" then return end

  -- pick a random environment
  if PARAM.environment_themes == "random" then
    each L in GAME.levels do
      L.outdoor_theme = rand.pick({"temperate","snow","desert"})
    end
  end

  -- just like a bit mixed - every 2-6 levels, the theme will change
  if PARAM.environment_themes == "mixed" then
    each L in GAME.levels do
      if L.id == 1 then
        L.outdoor_theme = rand.pick({"temperate","snow","desert"})
        PARAM.previous_theme = L.outdoor_theme
        PARAM.outdoor_theme_along = rand.irange(2,4)
      elseif L.id > 1 then
        -- continue the same theme until the countdown ends
        if PARAM.outdoor_theme_along > 0 then
          L.outdoor_theme = PARAM.previous_theme
          PARAM.outdoor_theme_along = PARAM.outdoor_theme_along - 1
        -- decide a new theme when the countdown ends
        -- logic goes that deserts cannot go to snow immediately
        -- and vice versa
        elseif PARAM.outdoor_theme_along <= 0 then
          if PARAM.previous_theme == "temperate" then
            L.outdoor_theme = rand.pick({"snow","desert"})
          else
            L.outdoor_theme = "temperate"
          end
          PARAM.previous_theme = L.outdoor_theme
          PARAM.outdoor_theme_along = rand.irange(2,4)
        end
      end
    end
  end

  -- -ish environment themes
  if PARAM.environment_themes == "snowish" then
    each L in GAME.levels do
      L.outdoor_theme = rand.pick({"temperate","snow"})
    end
  elseif PARAM.environment_themes == "desertish" then
    each L in GAME.levels do
      L.outdoor_theme = rand.pick({"temperate","desert"})
    end
  end

  -- absolutes
  if PARAM.environment_themes == "snow" then
    each L in GAME.levels do
      L.outdoor_theme = "snow"
    end
  elseif PARAM.environment_themes == "desert" then
    each L in GAME.levels do
      L.outdoor_theme = "desert"
    end
  end

  gui.printf("\n--==| Environment Outdoor Themes |==--\n\n")
  each L in GAME.levels do
    if L.outdoor_theme then
      gui.printf("Outdoor theme for " .. L.name .. ": " .. L.outdoor_theme .. "\n")
    end
  end
end

function ARMAETUS_EPIC_TEXTURES.generate_environment_themes()
  --------------------------------------
  -- Style Update for Custom Elements --
  --------------------------------------

  -- covers hallways only for now
  -- MSSP-TODO: revise this code to be more generic for future expansion
  if LEVEL.theme_name == "hell" then
    THEME.wide_halls.hellcata = 50 * style_sel("liquids", 0.3, 0.7, 1.2, 1.5)
                                  * style_sel("traps", 0.3, 0.7, 1.2, 1.5)
  elseif LEVEL.theme_name == "tech" or LEVEL.theme_name == "urban" then
    THEME.wide_halls.sewers = 50 * style_sel("liquids", 0.3, 0.7, 1.2, 1.5)
  end


  -- initialize default tables
  if not PARAM.default_environment_themes_init then
    -- Doom 2
    if OB_CONFIG.game == "doom2" then
      -- floors
      PARAM.def_tech_floors = GAME.ROOM_THEMES.tech_Outdoors_generic.floors
      PARAM.def_urban_floors = GAME.ROOM_THEMES.urban_Outdoors_generic.floors
      PARAM.def_hell_floors = GAME.ROOM_THEMES.hell_Outdoors_generic.floors
      -- naturals
      PARAM.def_tech_naturals = GAME.ROOM_THEMES.tech_Outdoors_generic.naturals
      PARAM.def_urban_naturals = GAME.ROOM_THEMES.urban_Outdoors_generic.naturals
      PARAM.def_hell_naturals = GAME.ROOM_THEMES.hell_Outdoors_generic.naturals
      -- cliff materials
      PARAM.def_tech_cliff_mats = GAME.THEMES.tech.cliff_mats
      PARAM.def_urban_cliff_mats = GAME.THEMES.urban.cliff_mats
      PARAM.def_hell_cliff_mats = GAME.THEMES.hell.cliff_mats

    -- Doom 1
    elseif OB_CONFIG.game == "doom1"
    or OB_CONFIG.game == "ultdoom" then
      -- floors
      PARAM.def_tech_floors = GAME.ROOM_THEMES.tech_Outdoors.floors
      PARAM.def_deimos_floors = GAME.ROOM_THEMES.deimos_Outdoors.floors
      PARAM.def_hell_floors = GAME.ROOM_THEMES.hell_Outdoors.floors
      PARAM.def_flesh_floors = GAME.ROOM_THEMES.flesh_Outdoors.floors
      -- naturals
      PARAM.def_tech_naturals = GAME.ROOM_THEMES.tech_Outdoors.naturals
      PARAM.def_deimos_naturals = GAME.ROOM_THEMES.deimos_Outdoors.naturals
      PARAM.def_hell_naturals = GAME.ROOM_THEMES.hell_Outdoors.naturals
      PARAM.def_flesh_naturals = GAME.ROOM_THEMES.flesh_Outdoors.naturals
      -- cliff materials
      PARAM.def_tech_cliff_mats = GAME.THEMES.tech.cliff_mats
      PARAM.def_deimos_cliff_mats = GAME.THEMES.deimos.cliff_mats
      PARAM.def_hell_cliff_mats = GAME.THEMES.hell.cliff_mats
      PARAM.def_flesh_cliff_mats = GAME.THEMES.flesh.cliff_mats
    end

    PARAM.default_environment_themes_init = true
  end

  -- checking in on custom outdoors
  -- snow
  local snow_floors = ARMAETUS_SNOW_OUTDOORS.floors
  local snow_naturals = ARMAETUS_SNOW_OUTDOORS.naturals
  local snow_facades = ARMAETUS_SNOW_FACADE
  local snow_cliffs = ARMAETUS_SNOW_CLIFF_MATS

  --sand
  local sand_floors = ARMAETUS_DESERT_OUTDOORS.floors
  local sand_naturals = ARMAETUS_DESERT_OUTDOORS.naturals
  local sand_facades = ARMAETUS_DESERT_FACADE
  local sand_cliffs = ARMAETUS_DESERT_CLIFF_MATS

  if OB_CONFIG.game == "doom2" then
    if LEVEL.outdoor_theme == "snow" then
      GAME.ROOM_THEMES.tech_Outdoors_generic.floors = snow_floors
      GAME.ROOM_THEMES.tech_Outdoors_generic.naturals = snow_naturals
      GAME.ROOM_THEMES.urban_Outdoors_generic.floors = snow_floors
      GAME.ROOM_THEMES.urban_Outdoors_generic.naturals = snow_naturals
      GAME.ROOM_THEMES.hell_Outdoors_generic.floors = snow_floors
      GAME.ROOM_THEMES.hell_Outdoors_generic.naturals = snow_naturals
      GAME.THEMES.tech.cliff_mats = snow_cliffs
      GAME.THEMES.urban.cliff_mats = snow_cliffs
      GAME.THEMES.hell.cliff_mats = snow_cliffs
    elseif LEVEL.outdoor_theme == "desert" then
      GAME.ROOM_THEMES.tech_Outdoors_generic.floors = sand_floors
      GAME.ROOM_THEMES.tech_Outdoors_generic.naturals = sand_naturals
      GAME.ROOM_THEMES.urban_Outdoors_generic.floors = sand_floors
      GAME.ROOM_THEMES.urban_Outdoors_generic.naturals = sand_naturals
      GAME.ROOM_THEMES.hell_Outdoors_generic.floors = sand_floors
      GAME.ROOM_THEMES.hell_Outdoors_generic.naturals = sand_naturals
      GAME.THEMES.tech.cliff_mats = sand_cliffs
      GAME.THEMES.urban.cliff_mats = sand_cliffs
      GAME.THEMES.hell.cliff_mats = sand_cliffs
    elseif LEVEL.outdoor_theme == "temperate" then
      GAME.ROOM_THEMES.tech_Outdoors_generic.floors = PARAM.def_tech_floors
      GAME.ROOM_THEMES.tech_Outdoors_generic.naturals = PARAM.def_tech_naturals
      GAME.ROOM_THEMES.urban_Outdoors_generic.floors = PARAM.def_urban_floors
      GAME.ROOM_THEMES.urban_Outdoors_generic.naturals = PARAM.def_urban_naturals
      GAME.ROOM_THEMES.hell_Outdoors_generic.floors = PARAM.def_hell_floors
      GAME.ROOM_THEMES.hell_Outdoors_generic.naturals = PARAM.def_hell_naturals
      GAME.THEMES.tech.cliff_mats = PARAM.def_tech_cliff_mats
      GAME.THEMES.urban.cliff_mats = PARAM.def_urban_cliff_mats
      GAME.THEMES.hell.cliff_mats = PARAM.def_hell_cliff_mats
    end
  -- MSSP-TODO: check cliff mats for Doom1
  elseif OB_CONFIG.game == "doom1"
  or OB_CONFIG.game == "ultdoom" then
    if LEVEL.outdoor_theme == "snow" then
      GAME.ROOM_THEMES.tech_Outdoors.floors = snow_floors
      GAME.ROOM_THEMES.tech_Outdoors.naturals = snow_naturals
      GAME.ROOM_THEMES.deimos_Outdoors.floors = snow_floors
      GAME.ROOM_THEMES.deimos_Outdoors.naturals = snow_naturals
      GAME.ROOM_THEMES.hell_Outdoors.floors = snow_floors
      GAME.ROOM_THEMES.hell_Outdoors.naturals = snow_naturals
      GAME.ROOM_THEMES.flesh_Outdoors.floors = snow_floors
      GAME.ROOM_THEMES.flesh_Outdoors.naturals = snow_naturals
    elseif LEVEL.outdoor_theme == "desert" then
      GAME.ROOM_THEMES.tech_Outdoors.floors = sand_floors
      GAME.ROOM_THEMES.tech_Outdoors.naturals = sand_naturals
      GAME.ROOM_THEMES.deimos_Outdoors.floors = sand_floors
      GAME.ROOM_THEMES.deimos_Outdoors.naturals = sand_naturals
      GAME.ROOM_THEMES.hell_Outdoors.floors = sand_floors
      GAME.ROOM_THEMES.hell_Outdoors.naturals = sand_naturals
      GAME.ROOM_THEMES.flesh_Outdoors.floors = sand_floors
      GAME.ROOM_THEMES.flesh_Outdoors.naturals = sand_naturals
    elseif LEVEL.outdoor_theme == "temperate" then
      GAME.ROOM_THEMES.tech_Outdoors.floors = PARAM.def_tech_floors
      GAME.ROOM_THEMES.tech_Outdoors.naturals = PARAM.def_tech_naturals
      GAME.ROOM_THEMES.deimos_Outdoors.floors = PARAM.def_deimos_floors
      GAME.ROOM_THEMES.deimos_Outdoors.naturals = PARAM.def_deimos_naturals
      GAME.ROOM_THEMES.hell_Outdoors.floors = PARAM.def_hell_naturals
      GAME.ROOM_THEMES.hell_Outdoors.naturals = PARAM.def_hell_naturals
      GAME.ROOM_THEMES.flesh_Outdoors.floors = PARAM.def_flesh_naturals
      GAME.ROOM_THEMES.flesh_Outdoors.naturals = PARAM.def_flesh_naturals
    end
  end
end

function ARMAETUS_EPIC_TEXTURES.table_insert(table1, table2)
  for x,y in pairs(table1) do
    table2[x] = y
  end
end

function ARMAETUS_EPIC_TEXTURES.put_new_materials()

  if OB_CONFIG.game == "doom2" then
    -- put the custom material definitions in the materials table!!!
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_MATERIALS,
      GAME.MATERIALS)

    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_LIQUIDS,
      GAME.LIQUIDS)

    -- put the custom theme definitions in the themes table!!!
    -- LIQUIDZ
    if PARAM.custom_liquids != "no" then
      ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_TECH_LIQUIDS,
        GAME.THEMES.tech.liquids)
      ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_URBAN_LIQUIDS,
        GAME.THEMES.urban.liquids)
      ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_HELL_LIQUIDS,
        GAME.THEMES.hell.liquids)
    end

    -- FACADES
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_TECH_FACADES,
      GAME.THEMES.tech.facades)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_HELL_FACADES,
      GAME.THEMES.hell.facades)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_URBAN_FACADES,
      GAME.THEMES.urban.facades)

    -- ROOM THEMES
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_THEMES,
      GAME.ROOM_THEMES)

    -- NATURALS
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_TECH_NATURALS,
      GAME.ROOM_THEMES.tech_Outdoors_generic.naturals)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_URBAN_NATURALS,
      GAME.ROOM_THEMES.urban_Outdoors_generic.naturals)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_HELL_NATURALS,
     GAME.ROOM_THEMES.hell_Outdoors_generic.naturals)

    -- SINKS
    -- definitions
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_SINK_DEFS,
      GAME.SINKS)

    -- ceiling sink tables
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_TECH_CEILING_SINKS,
      GAME.THEMES.tech.ceiling_sinks)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_URBAN_CEILING_SINKS,
      GAME.THEMES.urban.ceiling_sinks)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_HELL_CEILING_SINKS,
      GAME.THEMES.hell.ceiling_sinks)

    -- floor sink tables
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_TECH_FLOOR_SINKS,
      GAME.THEMES.tech.floor_sinks)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_URBAN_FLOOR_SINKS,
      GAME.THEMES.urban.floor_sinks)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_HELL_FLOOR_SINKS,
      GAME.THEMES.hell.floor_sinks)

    --new scenic fences feature
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_TECH_SCENIC_FENCES,
      GAME.THEMES.tech.scenic_fence)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_URBAN_SCENIC_FENCES,
      GAME.THEMES.urban.scenic_fence)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_HELL_SCENIC_FENCES,
      GAME.THEMES.hell.scenic_fence)

    -- inserts for group walls
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_TECH_WALL_GROUPS,
      GAME.THEMES.tech.wall_groups)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_URBAN_WALL_GROUPS,
      GAME.THEMES.urban.wall_groups)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_HELL_WALL_GROUPS,
      GAME.THEMES.hell.wall_groups)

    -- inserts for window groups
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_TECH_WINDOW_GROUPS,
      GAME.THEMES.tech.window_groups)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_URBAN_WINDOW_GROUPS,
      GAME.THEMES.urban.window_groups)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_HELL_WINDOW_GROUPS,
      GAME.THEMES.hell.window_groups)

    -- inserts for epic skyboxes
    GAME.THEMES.tech.skyboxes = ARMAETUS_TECH_SKYBOXES
    GAME.THEMES.urban.skyboxes = ARMAETUS_URBAN_SKYBOXES
    GAME.THEMES.hell.skyboxes = ARMAETUS_HELL_SKYBOXES

    -- inserts for hallways (should be updated and
    -- expanded in the future to be more
    -- generalized should anyone desire
    -- to add more custom hallway types)
    GAME.THEMES.tech.wide_halls = ARMAETUS_TECH_WIDE_HALLS
    GAME.THEMES.urban.wide_halls = ARMAETUS_TECH_WIDE_HALLS
    GAME.THEMES.hell.wide_halls = ARMAETUS_HELL_WIDE_HALLS

    -- hack for the street textures
    GAME.SINKS.floor_streets.trim_mat = "WARN1"
  end

  if OB_CONFIG.game == "doom1" or OB_CONFIG.game == "ultdoom" then
    -- put the custom material definitions in the materials table!!!
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_MATERIALS,
      GAME.MATERIALS)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_LIQUIDS,
      GAME.LIQUIDS)

    -- put the custom theme definitions in the themes table!!!
    -- LIQUIDZ
    if PARAM.custom_liquids != "yes" then
      ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_TECH_LIQUIDS,
        GAME.THEMES.tech.liquids[name])
      ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_DEIMOS_LIQUIDS,
        GAME.THEMES.deimos.liquids)
      ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_HELL_LIQUIDS,
        GAME.THEMES.hell.liquids)
    end

    -- FACADES
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_TECH_FACADES,
      GAME.THEMES.tech.facades)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_HELL_FACADES,
      GAME.THEMES.hell.facades)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_FLESH_FACADES,
      GAME.THEMES.flesh.facades)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_DEIMOS_FACADES,
      GAME.THEMES.deimos.facades)

    -- ROOM THEMES
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_THEMES,
      GAME.ROOM_THEMES)

    -- NATURALS
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_TECH_NATURALS,
      GAME.ROOM_THEMES.tech_Outdoors.naturals)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_DEIMOS_NATURALS,
      GAME.ROOM_THEMES.deimos_Outdoors.naturals)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_HELL_NATURALS,
      GAME.ROOM_THEMES.hell_Outdoors.naturals)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_FLESH_NATURALS,
      GAME.ROOM_THEMES.flesh_Outdoors.naturals)

    -- SINKS
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_SINK_DEFS,
      GAME.SINKS)
    -- ceiling sink tables
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_TECH_CEILING_SINKS,
      GAME.THEMES.tech.ceiling_sinks)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_DEIMOS_CEILING_SINKS,
      GAME.THEMES.deimos.ceiling_sinks)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_HELL_CEILING_SINKS,
      GAME.THEMES.hell.ceiling_sinks)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_FLESH_CEILING_SINKS,
      GAME.THEMES.flesh.ceiling_sinks)
    -- floor sink tables
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_TECH_FLOOR_SINKS,
      GAME.THEMES.tech.floor_sinks)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_DEIMOS_FLOOR_SINKS,
      GAME.THEMES.deimos.floor_sinks)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_HELL_FLOOR_SINKS,
      GAME.THEMES.hell.floor_sinks)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_FLESH_FLOOR_SINKS,
      GAME.THEMES.flesh.floor_sinks)

    --new scenic fences feature
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_TECH_SCENIC_FENCES,
      GAME.THEMES.tech.scenic_fence)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_DEIMOS_SCENIC_FENCES,
      GAME.THEMES.deimos.scenic_fence)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_HELL_SCENIC_FENCES,
      GAME.THEMES.hell.scenic_fence)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_FLESH_SCENIC_FENCES,
      GAME.THEMES.flesh.scenic_fence)

    -- inserts for group walls
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_TECH_WALL_GROUPS,
      GAME.THEMES.tech.wall_groups)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_DEIMOS_WALL_GROUPS,
      GAME.THEMES.deimos.wall_groups)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_HELL_WALL_GROUPS,
      GAME.THEMES.hell.wall_groups)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_FLESH_WALL_GROUPS,
      GAME.THEMES.flesh.wall_groups)

    -- inserts for window groups
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_TECH_WINDOW_GROUPS,
      GAME.THEMES.tech.window_groups)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_DEIMOS_WINDOW_GROUPS,
      GAME.THEMES.deimos.window_groups)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_HELL_WINDOW_GROUPS,
      GAME.THEMES.hell.window_groups)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_FLESH_WINDOW_GROUPS,
      GAME.THEMES.flesh.window_groups)

    -- inserts for epic skyboxes
    GAME.THEMES.tech.skyboxes = ARMAETUS_TECH_SKYBOXES
    GAME.THEMES.deimos.skyboxes = ARMAETUS_DEIMOS_SKYBOXES
    GAME.THEMES.hell.skyboxes = ARMAETUS_HELL_SKYBOXES
    GAME.THEMES.flesh.skyboxes = ARMAETUS_FLESH_SKYBOXES

    -- inserts for hallways
    GAME.THEMES.tech.wide_halls = ARMAETUS_TECH_WIDE_HALLS
    GAME.THEMES.deimos.wide_halls = ARMAETUS_TECH_WIDE_HALLS
    GAME.THEMES.hell.wide_halls = ARMAETUS_HELL_WIDE_HALLS
    GAME.THEMES.flesh.wide_halls = ARMAETUS_HELL_WIDE_HALLS

    --hack for the street textures
    GAME.SINKS.floor_streets.trim_mat = "WARN1"
  end
end

function ARMAETUS_EPIC_TEXTURES.put_the_texture_wad_in()
  local wad_file = "games/doom/data/ObAddon_Textures.wad"
  if PARAM.include_package != "no" then
    gui.wad_transfer_lump(wad_file, "ANIMDEFS", "ANIMDEFS")
    gui.wad_transfer_lump(wad_file, "CREDITS", "CREDITS")
    gui.wad_merge_sections(wad_file)

    -- wad_merge_sections currently does not support merging HI_START
    -- and HI_END... *sigh*
    gui.wad_add_binary_lump("HI_START",{})
    gui.wad_insert_file("games/doom/data/OBVNMCH1.png", "OBVNMCH1")
    gui.wad_insert_file("games/doom/data/OBVNMCH2.png", "OBVNMCH2")
    gui.wad_insert_file("games/doom/data/OBVNMCH3.png", "OBVNMCH3")
    gui.wad_insert_file("games/doom/data/OBVNMCH4.png", "OBVNMCH4")
    gui.wad_insert_file("games/doom/data/OBVNMCH5.png", "OBVNMCH5")
    gui.wad_add_binary_lump("HI_END",{})
  end

  if PARAM.custom_trees != "no" then
    gui.wad_merge_sections("modules/zdoom_internal_scripts/ObAddon_trees.wad")
    if PARAM.custom_trees == "zs" then
      gui.wad_insert_file("modules/zdoom_internal_scripts/ZSCRIPT.txt", "ZSCRIPT")
    elseif PARAM.custom_trees == "decorate" then
      gui.wad_insert_file("modules/zdoom_internal_scripts/DECORATE.txt", "DECORATE")
      gui.wad_insert_file("modules/zdoom_internal_scripts/LOADACS.txt", "LOADACS")
      gui.wad_add_binary_lump("A_START",{})
      gui.wad_insert_file("modules/zdoom_internal_scripts/ASSGRASS.lmp", "ASSGRASS")
      gui.wad_add_binary_lump("A_END",{})
    end
  end
end
----------------------------------------------------------------

OB_MODULES["armaetus_epic_textures"] =
{
  label = _("ZDoom: Armaetus Texture Pack")

  side = "left"
  priority = 70

  game = "doomish"

  hooks =
  {
    setup = ARMAETUS_EPIC_TEXTURES.setup
    get_levels_after_themes = ARMAETUS_EPIC_TEXTURES.decide_environment_themes
    begin_level = ARMAETUS_EPIC_TEXTURES.generate_environment_themes
    level_layout_finished = ARMAETUS_EPIC_TEXTURES.create_environment_themes
    all_done = ARMAETUS_EPIC_TEXTURES.put_the_texture_wad_in
  }

  tooltip = "If enabled, adds textures from Armaetus's Texture Pack, which also includes a few new custom texture exclusive prefabs."

  options =
  {
    custom_liquids =
    {
      name = "custom_liquids"
      label = _("Custom Liquids")
      choices = ARMAETUS_EPIC_TEXTURES.YES_NO
      default = "yes"
      tooltip = "Adds new custom Textures liquid flats."
      priority=4
    }

    custom_trees =
    {
      name = "custom_trees"
      label = _("Custom Trees")
      choices = ARMAETUS_EPIC_TEXTURES.SOUCEPORT_CHOICES
      default = "zs"
      tooltip =
        "Adds custom flat-depedendent tree sprites into the game. Currently only replaces " ..
        "trees on specific grass flats and will be expanded in the future to accomnodate " ..
        "custom Textures and more. If you are playing a mod that already does its own trees, " ..
        "it may be better to leave this off."
      priority=3
    }

    environment_themes =
    {
      name = "environment_themes"
      label = _("Environment Theme")
      choices = ARMAETUS_EPIC_TEXTURES.ENVIRONMENT_THEME_CHOICES
      default = "random"
      tooltip =
        "// THIS FEATURE IS CURRENTLY UNDER CONSTRUCTION \\\\\n" ..
        "Influences outdoor environments with different textures such as " ..
        "desert sand or icey snow."
      priority=2
      gap=1
    }

    include_package =
    {
      name = "include_package"
      label = _("Texture WAD Merge")
      choices = ARMAETUS_EPIC_TEXTURES.YES_NO
      default = "yes"
      tooltip =
        "Allows the trimming down of resulting WAD by not merging the custom texture WAD.\n\n" ..
        "This will require you to extract and load up the WAD manually in your preferred sourceport installation.\n\n" ..
        "This is the preferrable option for multiplayer situations and server owners and have each client obtain a copy of the texture pack instead.\n"
      priority=1
    }
  }
}
