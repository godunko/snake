--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

with A0B.ARMv7M.SysTick_Clock_Timer;

with Snake.Hardware;

procedure Snake.Driver is
begin
   A0B.ARMv7M.SysTick_Clock_Timer.Initialize
     (Use_Processor_Clock => True,
      Clock_Frequency     => 84_000_000);

   Snake.Hardware.Initialize;

   loop
      null;
   end loop;
end Snake.Driver;
