--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

with Snake.Colors;

package Snake.Display is

   procedure Initialize;

   procedure Set_Pixel
     (X  : Natural;
      Y  : Natural;
      To : Snake.Colors.R8G8B8_Color);

   procedure Update;

end Snake.Display;
