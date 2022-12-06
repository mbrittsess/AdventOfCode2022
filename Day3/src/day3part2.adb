with Ada.Text_IO; use Ada.Text_IO;

procedure Day3Part2 is
   subtype Letter is Character
     with Static_Predicate => Letter in 'A'..'Z'|'a'..'z';
   
   Letter_Error : Exception;

   type Priority is range 0 .. Integer'Last;
   package PIO is new Integer_IO(Priority);

   function Letter_Priority ( L : Letter ) return Priority is
   begin
      case L is
         when 'a'..'z' => return (Letter'Pos(L) - Letter'Pos('a'))+1;
         when 'A'..'Z' => return (Letter'Pos(L) - Letter'Pos('A'))+27;
      end case;
   end Letter_Priority;
   
   type Letter_Set is array( Character range <> ) of Boolean;
   
   type Encountered_Letters is
      record
         Lower : Letter_Set( 'a' .. 'z' );
         Upper : Letter_Set( 'A' .. 'Z' );
      end record;
   
   function Get ( EL : Encountered_Letters; L : Letter ) return Boolean is
   begin
      case L is
         when 'a' .. 'z' => return EL.Lower(L);
         when 'A' .. 'Z' => return EL.Upper(L);
      end case;
   end Get;
   
   procedure Set ( EL : in out Encountered_Letters; L : Letter ) is
   begin
      case L is
         when 'a' .. 'z' => EL.Lower(L) := true;
         when 'A' .. 'Z' => EL.Upper(L) := true;
      end case;
   end Set;
   
   procedure Set_All ( EL : in out Encountered_Letters ) is
   begin
      for L in Letter loop
         Set( EL, L );
      end loop;
   end Set_All;
   
   function "and" ( EL_Left, EL_Right : Encountered_Letters ) return Encountered_Letters is
   begin
      return ( Lower => EL_Left.Lower and EL_Right.Lower, Upper => EL_Left.Upper and EL_Right.Upper );
   end "and";
   
   function From_String ( Line : String ) return Encountered_Letters is
      Ret : Encountered_Letters := ( Lower => ( others => False ), Upper => ( others => False ) );
   begin
      for C of Line loop
         Set( Ret, Letter(C) );
      end loop;
      return Ret;
   end From_String;
   
   function First_Encountered ( EL : Encountered_Letters ) return Letter is
   begin
      for L in Letter loop
         if Get( EL, L ) then
            return L;
         end if;
      end loop;
      raise Letter_Error with "No seen letters";
   end First_Encountered;
   
   Total_Priority : Priority := 0;
begin
   while not End_Of_File loop
      declare
         Seen_Letters : Encountered_Letters := From_String( Get_Line );
      begin
         Seen_Letters := Seen_Letters and From_String( Get_Line );
         Seen_Letters := Seen_Letters and From_String( Get_Line );
         
         Total_Priority := Total_Priority + Letter_Priority( First_Encountered( Seen_Letters ) );
      end;
   end loop;
   
   PIO.Put( Total_Priority );
      
end Day3Part2;
