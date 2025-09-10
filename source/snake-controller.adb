--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

package body Snake.Controller is

   -------------------
   -- Set_Direction --
   -------------------

   procedure Change_Direction (To : Move_Direction) is
   begin
      case To is
         when Stop =>
            Direction := Stop;

         when Right =>
            if Direction /= Left then
               Direction := Right;
            end if;

         when Controller.Up =>
            if Direction /= Down then
               Direction := Up;
            end if;

         when Controller.Left =>
            if Direction /= Right then
               Direction := Left;
            end if;

         when Controller.Down =>
            if Direction /= Up then
               Direction := Down;
            end if;
      end case;
   end Change_Direction;

end Snake.Controller;
