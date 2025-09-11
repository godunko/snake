--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

pragma Ada_2022;

with Interfaces;

with A0B.ARMv7M.SysTick_Clock_Timer;

with Snake.Colors;
with Snake.Display;

procedure Snake.Driver is

   use type Interfaces.IEEE_Float_32;
   use type Interfaces.Unsigned_32;

   Cnt     : Interfaces.Unsigned_32 := 0 with Volatile;
   Cycle   : Integer := 0;

   Rainbow : array (0 .. 255) of Snake.Colors.R8G8B8_Color;

begin
   A0B.ARMv7M.SysTick_Clock_Timer.Initialize
     (Use_Processor_Clock => True,
      Clock_Frequency     => 84_000_000);

   Snake.Display.Initialize;

   for J in Rainbow'Range loop
      Rainbow (J) :=
        Snake.Colors.To_R8G8B8
          (Snake.Colors.To_RGB
             ((Hue        => (1.0 / 256.0) * Interfaces.IEEE_Float_32 (J),
               Saturation => 1.0,
               Lightness  => 0.02)));

   end loop;

   loop
      for J in 1 .. 100_000 loop
         Cnt := Cnt + 1;
      end loop;

      for J in Rainbow'Range loop
         Snake.Display.Set_Pixel ((J + Cycle) mod 256, Rainbow (J));
      end loop;

      Cycle := @ + 1;

      Snake.Display.Update;
   end loop;

   loop
      null;
   end loop;
end Snake.Driver;
