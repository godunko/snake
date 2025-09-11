--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

with A0B.STM32F401.GPIO.PIOB;

private package Snake.Display.Hardware is

   type Intensity is mod 2 ** 8;

   NEOPIXEL : A0B.STM32F401.GPIO.GPIO_Line
     renames A0B.STM32F401.GPIO.PIOB.PB4;

   procedure Initialize;

   procedure Set_Pixel
     (Index : Natural;
      R     : Intensity;
      G     : Intensity;
      B     : Intensity);

   procedure Update;

end Snake.Display.Hardware;
