------------------------------------------------------------------------
--  MODULE: Procedural Gotcha Fine Tune
------------------------------------------------------------------------
--
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
------------------------------------------------------------------------

PROCEDURAL_GOTCHA_FINE_TUNE = {}

PROCEDURAL_GOTCHA_FINE_TUNE.GOTCHA_STRENGTH_CHOICES =
{
  "none",    _("NONE"),
  "stronger", _("[+2] Stronger"),
  "harder", _("[+4] Harder"),
  "tougher", _("[+6] Tougher"),
  "crazier", _("[+8] CRAZIER"),
}

PROCEDURAL_GOTCHA_FINE_TUNE.GOTCHA_QUANTITY_CHOICES =
{
  "-50", _("-50% Monsters"),
  "-25", _("-25% Monsters"),
  "none",  _("NONE"),
  "25",  _("+25% Monsters"),
  "50",  _("+50% Monsters"),
  "100", _("+100% Monsters"),
  "200",  _("+200% Monsters"),
}



function PROCEDURAL_GOTCHA_FINE_TUNE.setup(self)
  for name,opt in pairs(self.options) do
    local value = self.options[name].value
    PARAM[name] = value
  end
end

OB_MODULES["procedural_gotcha"] =
{
  label = _("Procedural Gotcha Options")

  side = "right"
  priority = 92

  hooks =
  {
    setup = PROCEDURAL_GOTCHA_FINE_TUNE.setup
  }

  tooltip=_(
    "This module allows you to fine tune the Procedural Gotcha experience if you have Procedural Gotchas enabled. Does not affect prebuilts. It is recommended to pick higher scales on one of the two options, but not both at once for a balanced challenge.")

  options =
  {
    gotcha_qty =
    {
      name="gotcha_qty",
      label=_("Extra Quantity"),
      choices=PROCEDURAL_GOTCHA_FINE_TUNE.GOTCHA_QUANTITY_CHOICES,
      default="lots",
      tooltip = "Offset monster strength from your default quantity of choice plus the increasing level ramp. If your quantity choice is to reduce the monsters, the monster quantity will cap at a minimum of 0.1 (Scarce quantity setting).",
    }

    gotcha_strength =
    {
      name="gotcha_strength",
      label=_("Extra Strength"),
      choices=PROCEDURAL_GOTCHA_FINE_TUNE.GOTCHA_STRENGTH_CHOICES,
      default = "harder",
      tooltip = "Offset monster quantity from your default strength of choice plus the increasing level ramp.",
    }

  }

}
