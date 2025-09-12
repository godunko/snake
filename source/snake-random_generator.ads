--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

package Snake.Random_Generator is

   procedure Initialize;

   function Random_Row return Row_Index;

   function Random_Column return Column_Index;

end Snake.Random_Generator;
