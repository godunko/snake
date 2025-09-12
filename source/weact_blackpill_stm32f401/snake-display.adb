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
     (X  : Natural;
      Y  : Natural;
      To : Snake.Colors.R8G8B8_Color)
   is
      Row : constant Integer := 16 * Y;

   begin
      Snake.Display.Hardware.Set_Pixel
        (Index => 255 - Row - (if Y mod 2 = 0 then X else 15 - X),
         R     => Snake.Display.Hardware.Intensity (To.Red),
         G     => Snake.Display.Hardware.Intensity (To.Green),
         B     => Snake.Display.Hardware.Intensity (To.Blue));
   end Set_Pixel;

   ------------
   -- Update --
   ------------

   procedure Update renames Snake.Display.Hardware.Update;

end Snake.Display;
