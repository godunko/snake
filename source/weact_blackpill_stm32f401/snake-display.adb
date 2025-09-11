--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

with Snake.Display.Hardware;

package body Snake.Display is

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      Snake.Display.Hardware.Initialize;
   end Initialize;

   ---------------
   -- Set_Pixel --
   ---------------

   procedure Set_Pixel
     (Index : Natural;
      R     : Intensity;
      G     : Intensity;
      B     : Intensity) renames Snake.Display.Hardware.Set_Pixel;

   ------------
   -- Update --
   ------------

   procedure Update renames Snake.Display.Hardware.Update;

end Snake.Display;
