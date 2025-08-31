
pragma Ada_2022;

with Snake.Scene;

package body Snake.Font is

   type Bit is mod 2;

   type Glyph_Row is range 1 .. 5;

   type Glyph_Column is range 1 .. 3;

   type Glyph_Matrix is array (Glyph_Row, Glyph_Column) of Bit;

   Font : constant array (Natural range 0 .. 9) of Glyph_Matrix :=
     [0 =>
        [[1, 1, 1],
         [1, 0, 1],
         [1, 0, 1],
         [1, 0, 1],
         [1, 1, 1]],
      1 =>
        [[0, 1, 0],
         [1, 1, 0],
         [0, 1, 0],
         [0, 1, 0],
         [0, 1, 0]],
      2 =>
        [[0, 1, 0],
         [1, 0, 1],
         [0, 0, 1],
         [0, 1, 0],
         [1, 1, 1]],
      3 =>
        [[1, 1, 0],
         [0, 0, 1],
         [0, 1, 0],
         [0, 0, 1],
         [1, 1, 0]],
      4 =>
        [[1, 0, 1],
         [1, 0, 1],
         [1, 1, 1],
         [0, 0, 1],
         [0, 0, 1]],
      5 =>
        [[1, 1, 1],
         [1, 0, 0],
         [1, 1, 1],
         [0, 0, 1],
         [1, 1, 0]],
      6 =>
        [[1, 1, 1],
         [1, 0, 0],
         [1, 1, 1],
         [1, 0, 1],
         [1, 1, 1]],
      7 =>
        [[1, 1, 1],
         [0, 0, 1],
         [0, 1, 0],
         [0, 1, 0],
         [0, 1, 0]],
      8 =>
        [[1, 1, 1],
         [1, 0, 1],
         [0, 1, 0],
         [1, 0, 1],
         [1, 1, 1]],
      9 =>
        [[1, 1, 1],
         [1, 0, 1],
         [1, 1, 1],
         [0, 0, 1],
         [1, 1, 1]]];

   ----------
   -- Draw --
   ----------

   procedure Draw
     (Base_Row     : Row_Index;
      Start_Column : Column_Index;
      Item         : Natural) is
   begin
      for Row in Glyph_Row loop
         for Column in Glyph_Column loop
            if Font (Item) (Row, Column) /= 0 then
               Snake.Scene.Board
                 (Base_Row - 5 + Row_Index (Row),
                  Start_Column + Column_Index (Column) - 1) :=
                   Snake.Scene.Font;
            end if;
         end loop;
      end loop;
   end Draw;

end Snake.Font;
