--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2022;

package A0B.STM32F401.TIM_Function_Lines is

   TIM3_CH1  : aliased constant A0B.STM32F401.Function_Line_Descriptor;

   TIM10_CH1 : aliased constant A0B.STM32F401.Function_Line_Descriptor;

private

   TIM3_CH1  : aliased constant A0B.STM32F401.Function_Line_Descriptor :=
     [(A, 6, 2), (B, 4, 2), (C, 6, 2)];

   TIM10_CH1 : aliased constant A0B.STM32F401.Function_Line_Descriptor :=
     [(B, 8, 3)];

end A0B.STM32F401.TIM_Function_Lines;
