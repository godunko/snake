--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

with A0B.STM32F401.GPIO.PIOB;

package Snake.Hardware is

   TIM_ARR : constant := 105;  --  800 kHz when runs at 84 MHz
   TIM_T0H : constant := 33;   --  ~0.4 us
   TIM_T1H : constant := 67;   --  ~0.8 us

   NEOPIXEL : A0B.STM32F401.GPIO.GPIO_Line
     renames A0B.STM32F401.GPIO.PIOB.PB4;

   procedure Initialize;

end Snake.Hardware;
