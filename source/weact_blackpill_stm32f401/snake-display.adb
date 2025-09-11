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

end Snake.Display;
