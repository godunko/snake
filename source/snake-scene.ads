--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

with Snake.Controller;

package Snake.Scene is

   type Scene_Kind is (Game, Crash, Score);

   type Cell_Kind is (Empty, Wall, Apple, Creature, Crash, Font);

   type Game_Board is array (Row_Index, Column_Index) of Cell_Kind;

   Board         : Game_Board;
   State         : Scene_Kind;
   High_Score    : Natural := 0;
   Current_Score : Positive;

   procedure Initialize;

   procedure Move (New_Direction : Standard.Snake.Controller.Move_Direction);

private

   type Cell_Coordinate is record
      Row    : Row_Index;
      Column : Column_Index;
   end record;

   type Snake_Cell_Index is mod 256;

   type Cell_Coordinate_Array is array (Snake_Cell_Index) of Cell_Coordinate;

   type Snake_Information is record
      Head  : Snake_Cell_Index;
      Tail  : Snake_Cell_Index;
      Cells : Cell_Coordinate_Array;
   end record;

   Snake_Body : Snake_Information;
   Direction  : Controller.Move_Direction;

end Snake.Scene;
