
pragma Ada_2022;

with Ada.Numerics.Discrete_Random;

package body Snake.Scene is

   subtype Coordinate is Integer range 1 .. 16;

   package Coordinate_Random is new Ada.Numerics.Discrete_Random (Coordinate);

   Generator : Coordinate_Random.Generator;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      Controller.Direction := Controller.Stop;

      Board := [others => [others => (Empty)]];

      Snake_Body := (Head => 0, Tail => 0, others => [(8, 4), others => <>]);
      Board (8, 4) := Creature;

      Board (8, 12) := Apple;
   end Initialize;

   ----------
   -- Move --
   ----------

   procedure Move (New_Direction : Standard.Snake.Controller.Move_Direction) is
      use type Controller.Move_Direction;

      Head       : Cell_Coordinate := Snake_Body.Cells (Snake_Body.Head);
      Tail       : constant Cell_Coordinate :=
        Snake_Body.Cells (Snake_Body.Tail);
      Is_Crashed : constant Boolean := Board (Head.Row, Head.Column) = Crash;
      Move_Head  : Boolean := False;
      Move_Tail  : Boolean := True;

   begin
      if Is_Crashed then
         return;
      end if;

      case New_Direction is
         when Controller.Stop =>
            Direction := Controller.Stop;

         when Controller.Right =>
            if Direction /= Controller.Left then
               Direction := Controller.Right;
            end if;

         when Controller.Up =>
            if Direction /= Controller.Down then
               Direction := Controller.Up;
            end if;

         when Controller.Left =>
            if Direction /= Controller.Right then
               Direction := Controller.Left;
            end if;

         when Controller.Down =>
            if Direction /= Controller.Up then
               Direction := Controller.Down;
            end if;
      end case;

      case Direction is
         when Controller.Stop =>
            Move_Head := False;
            Move_Tail := False;

         when Controller.Right =>
            if Head.Column = Board'Last (1) then
               Board (Head.Row, Head.Column) := Crash;
               Snake_Body.Head := @ + 1;
               Snake_Body.Cells (Snake_Body.Head) := Head;

               return;

            else
               Head.Column := @ + 1;
               Move_Head := True;
            end if;

         when Controller.Up =>
            if Head.Row = Board'First (2) then
               Board (Head.Row, Head.Column) := Crash;
               Snake_Body.Head := @ + 1;
               Snake_Body.Cells (Snake_Body.Head) := Head;

               return;

            else
               Head.Row := @ - 1;
               Move_Head := True;
            end if;

         when Controller.Left =>
            if Head.Column = Board'First (1) then
               Board (Head.Row, Head.Column) := Crash;
               Snake_Body.Head := @ + 1;
               Snake_Body.Cells (Snake_Body.Head) := Head;

               return;

            else
               Head.Column := @ - 1;
               Move_Head := True;
            end if;

         when Controller.Down =>
            if Head.Row = Board'Last (2) then
               Board (Head.Row, Head.Column) := Crash;
               Snake_Body.Head := @ + 1;
               Snake_Body.Cells (Snake_Body.Head) := Head;

               return;

            else
               Head.Row := @ + 1;
               Move_Head := True;
            end if;
      end case;

      if Move_Head then
         if Board (Head.Row, Head.Column) = Apple then
            declare
               Row    : Coordinate;
               Column : Coordinate;

            begin
               Move_Tail := False;

               loop
                  Row    := Coordinate_Random.Random (Generator);
                  Column := Coordinate_Random.Random (Generator);

                  exit when Board (Row, Column) = Empty;
               end loop;

               Board (Row, Column) := Apple;
            end;

         elsif Board (Head.Row, Head.Column) = Creature then
            Board (Head.Row, Head.Column) := Crash;
            Snake_Body.Head := @ + 1;
            Snake_Body.Cells (Snake_Body.Head) := Head;

            return;
         end if;
      end if;

      if Move_Head then
         Board (Head.Row, Head.Column) := Creature;
         Snake_Body.Head := @ + 1;
         Snake_Body.Cells (Snake_Body.Head) := Head;
      end if;

      if Move_Tail then
         Board (Tail.Row, Tail.Column) := Empty;
         Snake_Body.Tail := @ + 1;
      end if;
   end Move;

end Snake.Scene;
