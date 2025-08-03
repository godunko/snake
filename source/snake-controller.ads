
package Snake.Controller is

   type Move_Direction is (Stop, Right, Up, Left, Down);

   Direction : Move_Direction;

   procedure Change_Direction (To : Move_Direction);

end Snake.Controller;
