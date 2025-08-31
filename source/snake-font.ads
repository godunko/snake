
pragma Restrictions (No_Elaboration_Code);

package Snake.Font is

   procedure Draw
     (Base_Row     : Row_Index;
      Start_Column : Column_Index;
      Item         : Natural);

end Snake.Font;
