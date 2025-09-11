--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

with A0B.ARMv7M.SysTick_Clock_Timer;

with Snake.Display;

procedure Snake.Driver is
   Cnt : Integer := 0 with Volatile;

begin
   A0B.ARMv7M.SysTick_Clock_Timer.Initialize
     (Use_Processor_Clock => True,
      Clock_Frequency     => 84_000_000);

   Snake.Display.Initialize;

   for C in 0 .. 7 loop
      for J in 1 .. 10_000_000 loop
         Cnt := Cnt + 1;
      end loop;

      Snake.Display.Set_Pixel (0, Snake.Display.Intensity (C * 32), 32, 32);
      Snake.Display.Set_Pixel (1, Snake.Display.Intensity (C * 32), 32, 32);
      Snake.Display.Set_Pixel (254, Snake.Display.Intensity (C * 32), 32, 32);
      Snake.Display.Set_Pixel (255, Snake.Display.Intensity (C * 32), 32, 32);
      Snake.Display.Update;
   end loop;

   loop
      null;
   end loop;
end Snake.Driver;
