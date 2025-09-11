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

   Scan_Interval   : constant A0B.Time.Time_Span := A0B.Time.Milliseconds (1);
   Pattern_Mask    : constant := 2#11_1111_1111#;
   Press_Pattern   : constant := 2#00_0000_0000#;
   Release_Pattern : constant := 2#11_1111_1111#;

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

   type Key_State is (Released, Pressed);

   type Key_Status is record
      State     : Key_State;
      Timestamp : A0B.Time.Monotonic_Time;
   end record;

   Up_State     : Key_Status;
   Down_State   : Key_Status;
   Left_State   : Key_Status;
   Right_State  : Key_Status;
   Middle_State : Key_Status;
   Set_State    : Key_Status;
   Reset_State  : Key_Status;

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

      Up_State     := (Released, Scan_Timestamp);
      Down_State   := (Released, Scan_Timestamp);
      Left_State   := (Released, Scan_Timestamp);
      Right_State  := (Released, Scan_Timestamp);
      Middle_State := (Released, Scan_Timestamp);
      Set_State    := (Released, Scan_Timestamp);
      Reset_State  := (Released, Scan_Timestamp);

      Scan_Timestamp := @ + Scan_Interval;
      A0B.Timer.Enqueue
        (Scan_Timer, Scan_Callbacks.Create_Callback, Scan_Timestamp);
   end Initialize;

   ---------------------
   -- Is_Down_Pressed --
   ---------------------

   function Is_Down_Pressed return Boolean is
   begin
      return Down_State.State = Pressed;
   end Is_Down_Pressed;

   ---------------------
   -- Is_Left_Pressed --
   ---------------------

   function Is_Left_Pressed return Boolean is
   begin
      return Left_State.State = Pressed;
   end Is_Left_Pressed;

   -----------------------
   -- Is_Middle_Pressed --
   -----------------------

   function Is_Middle_Pressed return Boolean is
   begin
      return Middle_State.State = Pressed;
   end Is_Middle_Pressed;

   ----------------------
   -- Is_Reset_Pressed --
   ----------------------

   function Is_Reset_Pressed return Boolean is
   begin
      return Reset_State.State = Pressed;
   end Is_Reset_Pressed;

   ----------------------
   -- Is_Right_Pressed --
   ----------------------

   function Is_Right_Pressed return Boolean is
   begin
      return Right_State.State = Pressed;
   end Is_Right_Pressed;

   --------------------
   -- Is_Set_Pressed --
   --------------------

   function Is_Set_Pressed return Boolean is
   begin
      return Set_State.State = Pressed;
   end Is_Set_Pressed;

   -------------------
   -- Is_Up_Pressed --
   -------------------

   function Is_Up_Pressed return Boolean is
   begin
      return Up_State.State = Pressed;
   end Is_Up_Pressed;

   ----------
   -- Scan --
   ----------

   procedure Scan is
      use type A0B.Time.Monotonic_Time;

      procedure Update_State
        (Key    : A0B.STM32F401.GPIO.GPIO_Line;
         Scan   : in out A0B.Types.Unsigned_32;
         Status : in out Key_Status);

      ------------------
      -- Update_State --
      ------------------

      procedure Update_State
        (Key    : A0B.STM32F401.GPIO.GPIO_Line;
         Scan   : in out A0B.Types.Unsigned_32;
         Status : in out Key_Status)
      is
         use type A0B.Types.Unsigned_32;

      begin
         Scan := A0B.Types.Shift_Left (@, 1);
         Scan := @ or (if Key.Get then 1 else 0);

         case Status.State is
            when Released =>
               if (Scan and Pattern_Mask) = Press_Pattern then
                  Status := (Pressed, Scan_Timestamp);
               end if;

            when Pressed =>
               if (Scan and Pattern_Mask) = Release_Pattern then
                  Status := (Released, Scan_Timestamp);
               end if;
         end case;
      end Update_State;

   begin
      Update_State (Up_Line, Up_Scan, Up_State);
      Update_State (Down_Line, Down_Scan, Down_State);
      Update_State (Left_Line, Left_Scan, Left_State);
      Update_State (Right_Line, Right_Scan, Right_State);
      Update_State (Middle_Line, Middle_Scan, Middle_State);
      Update_State (Set_Line, Set_Scan, Set_State);
      Update_State (Reset_Line, Reset_Scan, Reset_State);

      Scan_Timestamp := @ + Scan_Interval;
      A0B.Timer.Enqueue
        (Scan_Timer, Scan_Callbacks.Create_Callback, Scan_Timestamp);
   end Scan;

end Snake.Keypad;
