--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

pragma Ada_2022;

with A0B.Callbacks.Generic_Parameterless;
with A0B.Time.Clock;
with A0B.Timer;
with A0B.Types;

with A0B.STM32F401.GPIO.PIOA;

package body Snake.Keypad is

   Scan_Interval : constant A0B.Time.Time_Span := A0B.Time.Milliseconds (1);

   Up_Line     : A0B.STM32F401.GPIO.GPIO_Line
     renames A0B.STM32F401.GPIO.PIOA.PA6;
   Down_Line   : A0B.STM32F401.GPIO.GPIO_Line
     renames A0B.STM32F401.GPIO.PIOA.PA5;
   Left_Line   : A0B.STM32F401.GPIO.GPIO_Line
     renames A0B.STM32F401.GPIO.PIOA.PA4;
   Right_Line  : A0B.STM32F401.GPIO.GPIO_Line
     renames A0B.STM32F401.GPIO.PIOA.PA3;
   Middle_Line : A0B.STM32F401.GPIO.GPIO_Line
     renames A0B.STM32F401.GPIO.PIOA.PA2;
   Set_Line    : A0B.STM32F401.GPIO.GPIO_Line
     renames A0B.STM32F401.GPIO.PIOA.PA1;
   Reset_Line  : A0B.STM32F401.GPIO.GPIO_Line
     renames A0B.STM32F401.GPIO.PIOA.PA0;

   Scan_Timestamp : A0B.Time.Monotonic_Time;
   Scan_Timer     : aliased A0B.Timer.Timeout_Control_Block;

   Up_Scan     : A0B.Types.Unsigned_32 := 0;
   Down_Scan   : A0B.Types.Unsigned_32 := 0;
   Left_Scan   : A0B.Types.Unsigned_32 := 0;
   Right_Scan  : A0B.Types.Unsigned_32 := 0;
   Middle_Scan : A0B.Types.Unsigned_32 := 0;
   Set_Scan    : A0B.Types.Unsigned_32 := 0;
   Reset_Scan  : A0B.Types.Unsigned_32 := 0;

   procedure Scan;

   package Scan_Callbacks is
     new A0B.Callbacks.Generic_Parameterless (Scan);

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      use type A0B.Time.Monotonic_Time;

   begin
      Up_Line.Configure_Input (Pull => A0B.STM32F401.GPIO.Pull_Up);
      Down_Line.Configure_Input (Pull => A0B.STM32F401.GPIO.Pull_Up);
      Left_Line.Configure_Input (Pull => A0B.STM32F401.GPIO.Pull_Up);
      Right_Line.Configure_Input (Pull => A0B.STM32F401.GPIO.Pull_Up);
      Middle_Line.Configure_Input (Pull => A0B.STM32F401.GPIO.Pull_Up);
      Set_Line.Configure_Input (Pull => A0B.STM32F401.GPIO.Pull_Up);
      Reset_Line.Configure_Input (Pull => A0B.STM32F401.GPIO.Pull_Up);

      Scan_Timestamp := A0B.Time.Clock;

      Scan_Timestamp := @ + Scan_Interval;
      A0B.Timer.Enqueue
        (Scan_Timer, Scan_Callbacks.Create_Callback, Scan_Timestamp);
   end Initialize;

   ----------
   -- Scan --
   ----------

   procedure Scan is
      use type A0B.Time.Monotonic_Time;

      procedure Update_State
        (Key  : A0B.STM32F401.GPIO.GPIO_Line;
         Scan : in out A0B.Types.Unsigned_32);

      ------------------
      -- Update_State --
      ------------------

      procedure Update_State
        (Key  : A0B.STM32F401.GPIO.GPIO_Line;
         Scan : in out A0B.Types.Unsigned_32)
      is
         use type A0B.Types.Unsigned_32;

      begin
         Scan := A0B.Types.Shift_Left (@, 1);
         Scan := @ or (if Key.Get then 1 else 0);
      end Update_State;

   begin
      Update_State (Up_Line, Up_Scan);
      Update_State (Down_Line, Down_Scan);
      Update_State (Left_Line, Left_Scan);
      Update_State (Right_Line, Right_Scan);
      Update_State (Middle_Line, Middle_Scan);
      Update_State (Set_Line, Set_Scan);
      Update_State (Reset_Line, Reset_Scan);

      Scan_Timestamp := @ + Scan_Interval;
      A0B.Timer.Enqueue
        (Scan_Timer, Scan_Callbacks.Create_Callback, Scan_Timestamp);
   end Scan;

end Snake.Keypad;
