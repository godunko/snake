--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

package Snake.Display is

   type Intensity is mod 2 ** 8;

   procedure Initialize;

   procedure Set_Pixel
     (Index : Natural;
      R     : Intensity;
      G     : Intensity;
      B     : Intensity);

   procedure Update;

end Snake.Display;
