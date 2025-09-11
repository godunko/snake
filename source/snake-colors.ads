--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

with Interfaces;

package Snake.Colors is

   type RGB_Color is record
      Red   : Interfaces.IEEE_Float_32;
      Green : Interfaces.IEEE_Float_32;
      Blue  : Interfaces.IEEE_Float_32;
   end record;

   type HSL_Color is record
      Hue        : Interfaces.IEEE_Float_32;  --  [0.0 .. 1.0)
      Saturation : Interfaces.IEEE_Float_32;
      Lightness  : Interfaces.IEEE_Float_32;
   end record;

   type R8G8B8_Color is record
      Red   : Interfaces.Unsigned_8;
      Green : Interfaces.Unsigned_8;
      Blue  : Interfaces.Unsigned_8;
   end record;

   function To_R8G8B8 (Item : RGB_Color) return R8G8B8_Color;

   function To_RGB (Item : HSL_Color) return RGB_Color;

end Snake.Colors;
