--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

with A0B.STM32F401.SVD.RCC;
with A0B.STM32F401.SVD.TIM;
with A0B.STM32F401.TIM_Function_Lines;

package body Snake.Hardware is

   TIM : A0B.STM32F401.SVD.TIM.TIM10_Peripheral
     renames A0B.STM32F401.SVD.TIM.TIM10_Periph;

   procedure Initialize_TIM10;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      --  use A0B.STM32F401.SVD.TIM;

   begin
      Initialize_TIM10;

      NEOPIXEL.Configure_Alternative_Function
        (Line  => A0B.STM32F401.TIM_Function_Lines.TIM10_CH1,
         Mode  => A0B.STM32F401.GPIO.Push_Pull,
         Speed => A0B.STM32F401.GPIO.Very_High,
         Pull  => A0B.STM32F401.GPIO.Pull_Up);  --  ??? No ???

      --  NEOPIXEL.Configure_Output
      --    (Mode  => A0B.STM32F401.GPIO.Push_Pull,
      --     Speed => A0B.STM32F401.GPIO.Very_High,
      --     Pull  => A0B.STM32F401.GPIO.Pull_Up);  --  ??? No ???

      ---------------------------------------------------------------------

      --  RST

      for J in 1 .. 50 loop
         loop
            exit when TIM.SR.UIF;
         end loop;

         TIM.SR.UIF := False;
      end loop;

      for K in 1 .. 256 loop
         for J in 1 .. 24 loop
            if K mod 2 = 0 then
            --  if K < J then
               TIM.CCR1.CCR1 := TIM_T1H;

            else
               TIM.CCR1.CCR1 := TIM_T0H;
            end if;

            loop
               exit when TIM.SR.UIF;
            end loop;

            TIM.SR.UIF := False;
         end loop;
      end loop;
   end Initialize;

   ----------------------
   -- Initialize_TIM10 --
   ----------------------

   procedure Initialize_TIM10 is
      use A0B.STM32F401.SVD.TIM;

   begin
      A0B.STM32F401.SVD.RCC.RCC_Periph.APB2ENR.TIM10EN := True;

      --  CR1

      declare
         Aux : CR1_Register_2 := TIM.CR1;

      begin
         Aux.CEN  := False;
         Aux.UDIS := False;
         Aux.URS  := False;
         Aux.ARPE := False;  --  ??? True ???
         --  Aux.CKD  := 2#00#;      --  Digital filter, unused

         TIM.CR1 := Aux;
      end;

      --  ??? DIER

      --  ??? SR

      --  ??? EGR

      --  CCMR1

      declare
         Aux : CCMR1_Output_Register_2 := TIM.CCMR1_Output;

      begin
         Aux.CC1S  := 2#00#;  --  00: CC1 channel is configured as output.
         Aux.OC1FE := False;
         Aux.OC1PE := True;
         --  1: Preload register on TIMx_CCR1 enabled. Read/Write operations
         --  access the preload register. TIMx_CCR1 preload value is loaded
         --  in the active register at each update event.
         Aux.OC1M  := 2#110#;
         --  110: PWM mode 1 - Channel 1 is active as long as TIMx_CNT <
         --  TIMx_CCR1 else inactive.

         TIM.CCMR1_Output := Aux;
      end;

      --  CCER

      declare
         Aux : CCER_Register_3 := TIM.CCER;

      begin
         Aux.CC1NP := False;
         Aux.CC1P  := False;  --  0: OC1 active high
         Aux.CC1E  := True;
         --  1: On - OC1 signal is output on the corresponding output pin

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
         Aux : ARR_Register := TIM.ARR;

      begin
         Aux.ARR := TIM_ARR;

         TIM.ARR := Aux;
      end;

      --  CCR1

      declare
         Aux : CCR1_Register := TIM.CCR1;

      begin
         Aux.CCR1 := 0;

         TIM.CCR1 := Aux;
      end;

      TIM.CR1.CEN := True;
   end Initialize_TIM10;

end Snake.Hardware;
