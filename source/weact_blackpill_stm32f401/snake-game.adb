--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

pragma Ada_2022;

with A0B.Callbacks.Generic_Parameterless;
with A0B.Time.Clock;
with A0B.Timer;

with Snake.Colors;
with Snake.Controller;
with Snake.Display;
with Snake.Scene;

package body Snake.Game is

   Luminance      : constant := 0.05;
   Empty_Color    : constant Snake.Colors.R8G8B8_Color :=  --  black
     Snake.Colors.To_R8G8B8 (Snake.Colors.To_RGB ((0.0, 0.0, 0.0)));
   Wall_Color     : constant Snake.Colors.R8G8B8_Color :=  --  white
     Snake.Colors.To_R8G8B8 (Snake.Colors.To_RGB ((0.0, 0.0, Luminance)));
   Apple_Color    : constant Snake.Colors.R8G8B8_Color :=  --  yellow
     Snake.Colors.To_R8G8B8 (Snake.Colors.To_RGB ((0.125, 1.0, Luminance)));
   Creature_Color : constant Snake.Colors.R8G8B8_Color :=  --  green
     Snake.Colors.To_R8G8B8 (Snake.Colors.To_RGB ((0.333, 1.0, Luminance)));
   Crash_Color    : constant Snake.Colors.R8G8B8_Color :=  --  red
     Snake.Colors.To_R8G8B8 (Snake.Colors.To_RGB ((0.0, 1.0, Luminance)));
   Font_Color     : constant Snake.Colors.R8G8B8_Color :=  --  white
     Snake.Colors.To_R8G8B8 (Snake.Colors.To_RGB ((0.0, 0.0, Luminance)));

   Game_Interval  : constant A0B.Time.Time_Span := A0B.Time.Milliseconds (300);
   Game_Timestamp : A0B.Time.Monotonic_Time;

   Timer : aliased A0B.Timer.Timeout_Control_Block;

   procedure Cycle;

   package Cycle_Callbacks is
     new A0B.Callbacks.Generic_Parameterless (Cycle);

   -----------
   -- Cycle --
   -----------

   procedure Cycle is
      use type A0B.Time.Monotonic_Time;

   begin
      Snake.Scene.Move (Snake.Controller.Direction);

      for R in Snake.Scene.Board'Range (1) loop
         for C in Snake.Scene.Board'Range (2) loop
            Snake.Display.Set_Pixel
              (Integer (C) - Integer (Column_Index'First),
               Integer (R) - Integer (Row_Index'First),
               (case Snake.Scene.Board (R, C) is
                   when Snake.Scene.Empty => Empty_Color,
                   when Snake.Scene.Wall => Wall_Color,
                   when Snake.Scene.Apple => Apple_Color,
                   when Snake.Scene.Creature => Creature_Color,
                   when Snake.Scene.Crash => Crash_Color,
                   when Snake.Scene.Font => Font_Color));
         end loop;
      end loop;

      Snake.Display.Update;

      Game_Timestamp := @ + Game_Interval;
      A0B.Timer.Enqueue
        (Timer, Cycle_Callbacks.Create_Callback, Game_Timestamp);
   end Cycle;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      use type A0B.Time.Monotonic_Time;

   begin
      Game_Timestamp := A0B.Time.Clock;

      Game_Timestamp := @ + Game_Interval;
      A0B.Timer.Enqueue
        (Timer, Cycle_Callbacks.Create_Callback, Game_Timestamp);
   end Initialize;

end Snake.Game;
