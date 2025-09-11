--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

package body Snake.Colors is

   ---------------
   -- To_R8G8B8 --
   ---------------

   function To_R8G8B8 (Item : RGB_Color) return R8G8B8_Color is
      use type Interfaces.IEEE_Float_32;

   begin
      return
        (Red   => Interfaces.Unsigned_8 (Item.Red * 255.0),
         Green => Interfaces.Unsigned_8 (Item.Green * 255.0),
         Blue  => Interfaces.Unsigned_8 (Item.Blue * 255.0));
   end To_R8G8B8;

   ------------
   -- To_RGB --
   ------------

   function To_RGB (Item : HSL_Color) return RGB_Color is
      --  See https://en.wikipedia.org/wiki/HSL_and_HSV for details

      use type Interfaces.IEEE_Float_32;

      A : constant Interfaces.IEEE_Float_32 :=
        Item.Saturation
          * Interfaces.IEEE_Float_32'Min
              (Item.Lightness, 1.0 - Item.Lightness);

      function F
        (N : Interfaces.IEEE_Float_32) return Interfaces.IEEE_Float_32;

      -------
      -- F --
      -------

      function F
        (N : Interfaces.IEEE_Float_32) return Interfaces.IEEE_Float_32
      is
         K   : constant Interfaces.IEEE_Float_32 :=
           abs Interfaces.IEEE_Float_32'Remainder
             (N + Item.Hue * 12.0, 12.0);
         Min : constant Interfaces.IEEE_Float_32 :=
           Interfaces.IEEE_Float_32'Min
             (K - 3.0,
              Interfaces.IEEE_Float_32'Min (9.0 - K, 1.0));
         Max : constant Interfaces.IEEE_Float_32 :=
           Interfaces.IEEE_Float_32'Max (-1.0, Min);

      begin
         return Item.Lightness - A * Max;
      end F;

   begin
      return
        (Red   => F (0.0),
         Green => F (8.0),
         Blue  => F (4.0));
   end To_RGB;

end Snake.Colors;
