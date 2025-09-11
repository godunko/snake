--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

package Snake.Keypad is

   procedure Initialize;

   function Is_Up_Pressed return Boolean;

   function Is_Down_Pressed return Boolean;

   function Is_Left_Pressed return Boolean;

   function Is_Right_Pressed return Boolean;

   function Is_Middle_Pressed return Boolean;

   function Is_Set_Pressed return Boolean;

   function Is_Reset_Pressed return Boolean;

end Snake.Keypad;
