--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

--  This version of the package use random generator from standrd runtime.

with Ada.Numerics.Discrete_Random;

package body Snake.Random_Generator is

   subtype Coordinate is Integer range 1 .. 16;

   package Coordinate_Random is new Ada.Numerics.Discrete_Random (Coordinate);

   Generator : Coordinate_Random.Generator;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      null;
   end Initialize;

   -------------------
   -- Random_Column --
   -------------------

   function Random_Column return Column_Index is
   begin
      return Column_Index (Coordinate_Random.Random (Generator));
   end Random_Column;

   ----------------
   -- Random_Row --
   ----------------

   function Random_Row return Row_Index is
   begin
      return Row_Index (Coordinate_Random.Random (Generator));
   end Random_Row;

end Snake.Random_Generator;
