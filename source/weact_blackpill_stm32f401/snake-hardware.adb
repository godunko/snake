--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

with A0B.STM32F401.SVD.RCC;
with A0B.STM32F401.SVD.TIM;
with A0B.STM32F401.TIM_Function_Lines;

package body Snake.Hardware is

   TIM : A0B.STM32F401.SVD.TIM.TIM3_Peripheral
     renames A0B.STM32F401.SVD.TIM.TIM3_Periph;

   procedure Initialize_TIM3;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      Initialize_TIM3;

      NEOPIXEL.Configure_Alternative_Function
        (Line  => A0B.STM32F401.TIM_Function_Lines.TIM3_CH1,
         Mode  => A0B.STM32F401.GPIO.Push_Pull,
         Speed => A0B.STM32F401.GPIO.Very_High,
         Pull  => A0B.STM32F401.GPIO.Pull_Up);  --  ??? No ???

      ---------------------------------------------------------------------

      --  RST

      for J in 1 .. 50 loop
         loop
            exit when TIM.SR.UIF;
         end loop;

         TIM.SR.UIF := False;
      end loop;

      for K in 1 .. 59 loop
         for J in 1 .. 24 loop
            if K mod 2 = 0 then
            --  if K < J then
               TIM.CCR1.CCR1_L := TIM_T1H;

            else
               TIM.CCR1.CCR1_L := TIM_T0H;
            end if;

            loop
               exit when TIM.SR.UIF;
            end loop;

            TIM.SR.UIF := False;
         end loop;
      end loop;

      TIM.CCR1.CCR1_L := 0;
   end Initialize;

   ---------------------
   -- Initialize_TIM3 --
   ---------------------

   procedure Initialize_TIM3 is
      use A0B.STM32F401.SVD.TIM;

   begin
      A0B.STM32F401.SVD.RCC.RCC_Periph.APB1ENR.TIM3EN := True;

      --  CR1

      declare
         Aux : CR1_Register := TIM.CR1;

      begin
         Aux.CEN  := False;
         Aux.UDIS := False;
         Aux.URS  := False;
         Aux.OPM  := False;  --  0: Counter is not stopped at update event
         Aux.DIR  := False;  --  0: Counter used as upcounter
         Aux.CMS  := 2#00#;
         --  00: Edge-aligned mode. The counter counts up or down depending on
         --  the direction bit (DIR).
         Aux.ARPE := False;  --  ??? True ???
         --  Aux.CKD  := 2#00#;      --  Digital filter, unused

         TIM.CR1 := Aux;
      end;

      --  CR2

      declare
         Aux : CR2_Register_1 := TIM.CR2;

      begin
         Aux.CCDS := True;
         --  1: CCx DMA requests sent when update event occurs
         Aux.MMS  := 2#000#;  --  Unused
         Aux.TI1S := False;
         --  0: The TIMx_CH1 pin is connected to TI1 input

         TIM.CR2 := Aux;
      end;

      --  ??? SMCR

      --  ??? DIER

      --  ??? SR

      --  ??? EGR

      --  CCMR1

      declare
         Aux : CCMR1_Output_Register := TIM.CCMR1_Output;

      begin
         Aux.CC1S  := 2#00#;  --  00: CC1 channel is configured as output.
         Aux.OC1FE := False;
         --  0: CC1 behaves normally depending on counter and CCR1 values even
         --  when the trigger is ON. The minimum delay to activate CC1 output
         --  when an edge occurs on the trigger input is 5 clock cycles.
         Aux.OC1PE := True;
         --  1: Preload register on TIMx_CCR1 enabled. Read/Write operations
         --  access the preload register. TIMx_CCR1 preload value is loaded
         --  in the active register at each update event.
         Aux.OC1M  := 2#110#;
         --  110: PWM mode 1 - Channel 1 is active as long as TIMx_CNT <
         --  TIMx_CCR1 else inactive.
         Aux.OC1CE := False;
         --  0: OC1Ref is not affected by the ETRF input

         TIM.CCMR1_Output := Aux;
      end;

      --  ??? CCMR2

      --  CCER

      declare
         Aux : CCER_Register_1 := TIM.CCER;

      begin
         Aux.CC1E  := True;
         --  1: On - OC1 signal is output on the corresponding output pin
         Aux.CC1P  := False;  --  0: OC1 active high
         Aux.CC1NP := False;  --  CC1NP must be kept cleared in this case.

         TIM.CCER := Aux;
      end;

      --  CNT

      --  PSC

      declare
         Aux : PSC_Register := TIM.PSC;

      begin
         Aux.PSC := 0;

         TIM.PSC := Aux;
      end;

      --  ARR

      declare
         Aux : ARR_Register_1 := TIM.ARR;

      begin
         Aux.ARR_L := TIM_ARR;

         TIM.ARR := Aux;
      end;

      --  CCR1

      declare
         Aux : CCR1_Register_1 := TIM.CCR1;

      begin
         Aux.CCR1_L := 0;

         TIM.CCR1 := Aux;
      end;

      --  ??? DCR

      --  ??? DMAR

      TIM.CR1.ARPE := True;
      TIM.CR1.CEN  := True;
   end Initialize_TIM3;

end Snake.Hardware;
