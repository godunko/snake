--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

pragma Ada_2022;

with A0B.ARMv7M.Instructions;
with A0B.ARMv7M.SysTick_Clock_Timer;

with Snake.Display;
with Snake.Game;
with Snake.Keypad;
with Snake.Random_Generator;
with Snake.Scene;

procedure Snake.Driver is
begin
   A0B.ARMv7M.SysTick_Clock_Timer.Initialize
     (Use_Processor_Clock => True,
      Clock_Frequency     => 84_000_000);

   Snake.Display.Initialize;
   Snake.Keypad.Initialize;
   Snake.Random_Generator.Initialize;
   Snake.Scene.Initialize;
   Snake.Game.Initialize;

   loop
      A0B.ARMv7M.Instructions.Wait_For_Interrupt;
   end loop;
end Snake.Driver;
