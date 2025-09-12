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
with Snake.Keypad;

procedure Snake.Driver is

   use type Interfaces.IEEE_Float_32;
   use type Interfaces.Unsigned_32;

   Cnt       : Interfaces.Unsigned_32 := 0 with Volatile;
   Cycle     : Integer := 0;
   Speed     : Natural := 0;
   Direction : Integer := 1;

   --  Rainbow : array (0 .. 255) of Snake.Colors.R8G8B8_Color;
   Rainbow : array (0 .. 15) of Snake.Colors.R8G8B8_Color;

begin
   A0B.ARMv7M.SysTick_Clock_Timer.Initialize
     (Use_Processor_Clock => True,
      Clock_Frequency     => 84_000_000);

   Snake.Display.Initialize;
   Snake.Keypad.Initialize;

   for J in Rainbow'Range loop
      Rainbow (J) :=
        Snake.Colors.To_R8G8B8
          (Snake.Colors.To_RGB
             ((Hue        =>
                 (1.0 / Interfaces.IEEE_Float_32 (Rainbow'Length))
                    * Interfaces.IEEE_Float_32 (J),
               Saturation => 1.0,
               Lightness  => 0.02)));

   end loop;

   loop
      for J in 1 .. 200_000 loop
         Cnt := Cnt + 1;
      end loop;

      for J in Rainbow'Range loop
         Snake.Display.Set_Pixel
           ((J + Cycle) mod 16, (J + Cycle) mod 16, Rainbow (J));
      --     Snake.Display.Set_Pixel ((J + Cycle) mod 256, Rainbow (J));
      end loop;

      if Snake.Keypad.Is_Down_Pressed then
         Direction := -1;

      elsif Snake.Keypad.Is_Up_Pressed then
         Direction := 1;

      elsif Snake.Keypad.Is_Left_Pressed then
         Speed := Natural'Max (0, @ - 1);

      elsif Snake.Keypad.Is_Right_Pressed then
         Speed := @ + 1;

      elsif Snake.Keypad.Is_Reset_Pressed then
         Speed := 0;
      end if;

      Cycle := @ + Direction * Speed / 64;

      Snake.Display.Update;
   end loop;

   loop
      null;
   end loop;
end Snake.Driver;
