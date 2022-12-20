package body Input is

   function Get_All_Lines return String_Collection is
      function Recurse ( Accum : String_Collection ) return String_Collection is
         Next : String_Collection( 1 .. 1 ) := ( 1 => new String'( Get_Line ) );
         New_Accum : String_Collection := Accum & Next;
      begin
         if End_Of_File then
            return New_Accum;
         else
            return Recurse( New_Accum );
         end if;
      end Recurse;
      Start : String_Collection( 1 .. 1 ) := ( 1 => new String'( Get_Line ) );
   begin
      return Recurse( Start );
   end Get_All_Lines;

end Input;
