with Ada.Text_IO; use Ada.Text_IO;

procedure Day6Part2 is
   Prefix_Length : constant := 14;
   Buf : String( 1 .. Prefix_Length );
   Cur_Pos : Natural := 0;
   
   package NIO is new Integer_IO( Natural );
   
   function Start_Of_Message return Boolean is
   begin
      return (for all I in Buf'First .. Buf'Last-1 =>
                (for all J in I+1 .. Buf'Last => Buf(I) /= Buf(J)));
   end Start_Of_Message;
begin
   Get( Buf ); --out
   Cur_Pos := Prefix_Length;
   
   while not Start_Of_Message loop
      Buf( Buf'First .. Buf'Last-1 ) := Buf( Buf'First+1 .. Buf'Last );
      Get( Buf( Buf'Last ) ); --out
      Cur_Pos := Cur_Pos + 1;
   end loop;
   
   NIO.Put( Cur_Pos );
end Day6Part2;
