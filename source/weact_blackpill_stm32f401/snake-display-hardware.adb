--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

pragma Ada_2022;

with System.Storage_Elements;

with A0B.STM32F401.SVD.DMA;
with A0B.STM32F401.SVD.RCC;
with A0B.STM32F401.SVD.TIM;
with A0B.STM32F401.TIM_Function_Lines;
with A0B.Types;

package body Snake.Display.Hardware is

   PIXELS : constant := 256;

   PIXEL_PWM_CYCLES : constant := 24;
   --  Number of PWM cycles to send pixel's state
   RST_PWM_CYCLES   : constant := 40;
   --  Number of PWM cycles to send RST command

   TIM_ARR     : constant := 105 - 1;  --  800 kHz when runs at 84 MHz
   TIM_CCR_RST : constant := 0;        --  line is inactive (low level)
   TIM_CCR_DIS : constant := TIM_ARR + 1;
   TIM_CCR_T0H : constant := 34;       --  ~0.4 us
   TIM_CCR_T1H : constant := 67;       --  ~0.8 us

   TIM : A0B.STM32F401.SVD.TIM.TIM3_Peripheral
     renames A0B.STM32F401.SVD.TIM.TIM3_Periph;
   DMA : A0B.STM32F401.SVD.DMA.DMA_Peripheral
     renames A0B.STM32F401.SVD.DMA.DMA1_Periph;

   Buffer : array (0 .. RST_PWM_CYCLES + (PIXELS * PIXEL_PWM_CYCLES))
              of A0B.Types.Unsigned_16 with Volatile;
   --  DMA data buffer. First RST_PWM_CYCLES items are used to send RST
   --  command. Last item is used to force stable output level after
   --  data transmission.

   procedure Initialize_DMA1_CH5_Stream2;

   procedure Initialize_TIM3;

   procedure Enable_TIM3;

   -----------------
   -- Enable_TIM3 --
   -----------------

   procedure Enable_TIM3 is
   begin
      TIM.CR1.ARPE := True;
      TIM.CR1.CEN  := True;
   end Enable_TIM3;

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

      Initialize_DMA1_CH5_Stream2;

      Enable_TIM3;

      --  Fill DMA buffer to clear screen

      Buffer (0 .. RST_PWM_CYCLES - 1) := [others => TIM_CCR_RST];
      Buffer (RST_PWM_CYCLES
                .. RST_PWM_CYCLES + (PIXELS * PIXEL_PWM_CYCLES) - 1) :=
        [others => TIM_CCR_T0H];
      Buffer (Buffer'Last) := TIM_CCR_RST;

      --  Update screen

      Update;
   end Initialize;

   ---------------------------------
   -- Initialize_DMA1_CH5_Stream2 --
   ---------------------------------

   procedure Initialize_DMA1_CH5_Stream2 is
      use A0B.STM32F401.SVD.DMA;

   begin
      A0B.STM32F401.SVD.RCC.RCC_Periph.AHB1ENR.DMA1EN := True;

      --  ??? LSIR

      --  ??? HISR

      --  ??? LIFCR

      --  ??? HIFCR

      --  SxCR

      declare
         Aux : S2CR_Register := DMA.S2CR;

      begin
         Aux.EN     := False;   --  0: Stream disabled
         Aux.DMEIE  := False;   --  0: DME interrupt disabled
         Aux.TEIE   := False;   --  0: TE interrupt disabled
         Aux.HTIE   := False;   --  0: HT interrupt disabled
         Aux.TCIE   := False;   --  0: TC interrupt disabled
         Aux.PFCTRL := False;   --  0: The DMA is the flow controller
         Aux.DIR    := 2#01#;   --  01: Memory-to-peripheral
         Aux.CIRC   := False;   --  0: Circular mode disabled
         Aux.PINC   := False;   --  0: Peripheral address pointer is fixed
         Aux.MINC   := True;
         --  1: Memory address pointer is incremented after each data transfer
         --  (increment is done according to MSIZE)
         --  Aux.PSIZE  := 2#10#;   --  10: word (32-bit)
         Aux.PSIZE  := 2#01#;   --  01: half-word (16-bit)
         Aux.MSIZE  := 2#01#;   --  01: half-word (16-bit)
         Aux.PINCOS := True;
         --  1: The offset size for the peripheral address calculation is
         --  fixed to 4 (32-bit alignment).
         Aux.PL     := 2#10#;   --  10: High
         --  Aux.DMB    := False;
         --  0: No buffer switching at the end of transfer
         Aux.CT     := False;   --  Unused
         Aux.PBURST := 2#00#;   --  00: single transfer
         Aux.MBURST := 2#00#;   --  00: single transfer
         Aux.CHSEL  := 2#101#;  --  101: channel 5 selected

         DMA.S2CR := Aux;
      end;

      --  ??? SxNDTR

      --  SxPAR

      DMA.S2PAR :=
        A0B.Types.Unsigned_32
          (System.Storage_Elements.To_Integer (TIM.DMAR'Address));

      --  ??? SxM0AR

      --  ??? SxM1AR

      --  ??? SxFCR
   end Initialize_DMA1_CH5_Stream2;

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

      --  DIER

      declare
         Aux : DIER_Register_1 := TIM.DIER;

      begin
         Aux.UIE   := False;  --  0: Update interrupt disabled
         Aux.CC1IE := False;  --  0: CC1 interrupt disabled
         Aux.TIE   := False;  --  0: Trigger interrupt disabled.
         Aux.UDE   := True;   --  1: Update DMA request enabled.
         Aux.CC1DE := False;  --  0: CC1 DMA request disabled.

         TIM.DIER := Aux;
      end;

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
         Aux.CCR1_L := TIM_CCR_DIS;

         TIM.CCR1 := Aux;
      end;

      --  DCR

      declare
         Aux : DCR_Register := TIM.DCR;

      begin
         Aux.DBA := 13;        --  CCR1
         Aux.DBL := 2#00000#;  --  00000: 1 transfer

         TIM.DCR := Aux;
      end;

      --  ??? DMAR
   end Initialize_TIM3;

   ---------------
   -- Set_Pixel --
   ---------------

   procedure Set_Pixel
     (Index : Natural;
      R     : Intensity;
      G     : Intensity;
      B     : Intensity)
   is
      use type A0B.Types.Unsigned_8;

      pragma Suppress (All_Checks);
      Aux    : A0B.Types.Unsigned_8;
      Offset : Natural :=
        RST_PWM_CYCLES + Index * PIXEL_PWM_CYCLES;

   begin
      Aux := A0B.Types.Unsigned_8 (G);

      for J in 1 .. 8 loop
         Buffer (Offset) :=
           (if (Aux and 2#1000_0000#) = 0 then TIM_CCR_T0H else TIM_CCR_T1H);

         Aux    := A0B.Types.Shift_Left (@, 1);
         Offset := @ + 1;
      end loop;

      Aux := A0B.Types.Unsigned_8 (R);

      for J in 1 .. 8 loop
         Buffer (Offset) :=
           (if (Aux and 2#1000_0000#) = 0 then TIM_CCR_T0H else TIM_CCR_T1H);

         Aux    := A0B.Types.Shift_Left (@, 1);
         Offset := @ + 1;
      end loop;

      Aux := A0B.Types.Unsigned_8 (B);

      for J in 1 .. 8 loop
         Buffer (Offset) :=
           (if (Aux and 2#1000_0000#) = 0 then TIM_CCR_T0H else TIM_CCR_T1H);

         Aux    := A0B.Types.Shift_Left (@, 1);
         Offset := @ + 1;
      end loop;
   end Set_Pixel;

   ------------
   -- Update --
   ------------

   procedure Update is
   begin
      DMA.S2M0AR :=
        A0B.Types.Unsigned_32
          (System.Storage_Elements.To_Integer (Buffer'Address));
      DMA.S2NDTR.NDT := Buffer'Length;
      DMA.LIFCR :=
        (CFEIF2  => True,
         CDMEIF2 => True,
         CTEIF2  => True,
         CHTIF2  => True,
         CTCIF2  => True,
         others  => <>);
      DMA.S2CR.EN := True;
   end Update;

end Snake.Display.Hardware;
