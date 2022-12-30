with Ada.Text_IO;

package body Jets is
   
   subtype Direction_Character is Character with Static_Predicate => Direction_Character in '<'|'>';

   Input : String := Ada.Text_IO.Get_Line;
   
   Cur_Input_Index : Positive := Input'First;
   
   function Get_Jet_Direction return Direction is
      Char : Direction_Character := Input(Cur_Input_Index);
   begin
      if Cur_Input_Index = Input'Last then
         Cur_Input_Index := Input'First;
      else
         Cur_Input_Index := Cur_Input_Index + 1;
      end if;
      case Char is
         when '<' => return Left;
         when '>' => return Right;
      end case;
   end Get_Jet_Direction;
   
   function Get_Cur_Index return Natural is (Cur_Input_Index);

end Jets;
