--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

pragma Ada_2022;

with Snake.Font;
with Snake.Random_Generator;

package body Snake.Scene is

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      Controller.Direction := Controller.Stop;

      Board         := [others => [others => (Empty)]];
      State         := Game;
      Current_Score := 1;

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
      Move_Head  : Boolean := False;
      Move_Tail  : Boolean := True;

   begin
      if State = Crash then
         State := Score;

         Board := [others => [others => Empty]];

         return;

      elsif State = Score then
         declare
            N1 : constant Natural := Current_Score / 100;
            N2 : constant Natural := Current_Score / 10 mod 10;
            N3 : constant Natural := Current_Score mod 10;

         begin
            if N1 /= 0 then
               Snake.Font.Draw (6, 3, N1);
            end if;

            if N2 /= 0 then
               Snake.Font.Draw (6, 8, N2);
            end if;

            Snake.Font.Draw (6, 13, N3);
         end;

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
            if Head.Column = Board'Last (2) then
               Board (Head.Row, Head.Column) := Crash;
               State := Crash;
               Snake_Body.Head := @ + 1;
               Snake_Body.Cells (Snake_Body.Head) := Head;

               return;

            else
               Head.Column := @ + 1;
               Move_Head := True;
            end if;

         when Controller.Up =>
            if Head.Row = Board'First (1) then
               Board (Head.Row, Head.Column) := Crash;
               State := Crash;
               Snake_Body.Head := @ + 1;
               Snake_Body.Cells (Snake_Body.Head) := Head;

               return;

            else
               Head.Row := @ - 1;
               Move_Head := True;
            end if;

         when Controller.Left =>
            if Head.Column = Board'First (2) then
               Board (Head.Row, Head.Column) := Crash;
               State := Crash;
               Snake_Body.Head := @ + 1;
               Snake_Body.Cells (Snake_Body.Head) := Head;

               return;

            else
               Head.Column := @ - 1;
               Move_Head := True;
            end if;

         when Controller.Down =>
            if Head.Row = Board'Last (1) then
               Board (Head.Row, Head.Column) := Crash;
               State := Crash;
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
               Row    : Row_Index;
               Column : Column_Index;

            begin
               Move_Tail     := False;
               Current_Score := @ + 1;

               loop
                  Row    := Snake.Random_Generator.Random_Row;
                  Column := Snake.Random_Generator.Random_Column;

                  exit when Board (Row, Column) = Empty;
               end loop;

               Board (Row, Column) := Apple;
            end;

         elsif Board (Head.Row, Head.Column) = Creature then
            Board (Head.Row, Head.Column) := Crash;
            State := Crash;
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
