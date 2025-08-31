
with Snake.Controller;

package Snake.Scene is

   type Cell_Kind is (Empty, Wall, Apple, Creature, Crash);

   type Row_Index is range 1 .. 16;

   type Column_Index is range 1 .. 16;

   type Game_Board is array (Row_Index, Column_Index) of Cell_Kind;

   Board : Game_Board;

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
