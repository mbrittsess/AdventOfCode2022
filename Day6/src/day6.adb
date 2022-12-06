with Ada.Text_IO; use Ada.Text_IO;

procedure Day6 is
   Last_Four : String( 1 .. 4 );
   Cur_Pos : Natural := 0;

   package NIO is new Integer_IO( Natural );

   function Start_Of_Packet return Boolean is
   begin
      -- A nested quantified expression could have worked here, but I chose to keep it simple for now.
      for I in Last_Four'First .. (Last_Four'Last-1) loop
         if (for some J in (I+1) .. Last_Four'Last => Last_Four(I) = Last_Four(J)) then
            return false;
         end if;
      end loop;
      return true;
   end Start_Of_Packet;
begin
   Get( Last_Four ); --out
   Cur_Pos := 4;

   while not Start_Of_Packet loop
      Last_Four( 1 .. 3 ) := Last_Four ( 2 .. 4 );
      Get( Last_Four( 4 ) ); --out
      Cur_Pos := Cur_Pos + 1;
   end loop;

   NIO.Put( Cur_Pos );
end Day6;
