with A0B.ARMv7M.SysTick_Clock_Timer;

procedure Snake.Driver is
begin
   A0B.ARMv7M.SysTick_Clock_Timer.Initialize
     (Use_Processor_Clock => True,
      Clock_Frequency     => 72_000_000);

   loop
      null;
   end loop;
end Snake.Driver;
