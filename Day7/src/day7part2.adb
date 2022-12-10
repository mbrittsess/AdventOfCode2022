with Ada.Text_IO; use Ada.Text_IO;
with Filesystem; use Filesystem;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure Day7Part2 is
   Unexpected_Input : exception;
   
   Total_Space : constant Natural := 70_000_000;
   Required_Free_Space : constant Natural := 30_000_000;
   
   Used_Space : Natural;
   
   Desired_Size : Natural := Natural'Last;
   procedure Process_Directory ( Size : Natural ) is
      Resulting_Free_Space : Natural := Total_Space - ( Used_Space - Size );
   begin
      if Resulting_Free_Space >= Required_Free_Space and then Size < Desired_Size then
         Desired_Size := Size;
      end if;
   end Process_Directory;
   
   procedure Process_Cmd ( Line : String ) is
      Cmd : String := Line( Line'First+2 .. Line'Last );
   begin
      if Cmd = "ls" then
         null;
      elsif Cmd( Cmd'First .. Cmd'First+1 ) = "cd" then
         declare
            Arg : String := Cmd( Cmd'First+3 .. Cmd'Last );
         begin
            if Arg = "/" then
               Move_To_Root;
            elsif Arg = ".." then
               Move_To_Parent;
            else
               Move_To_Child( Arg );
            end if;
         end;
      else
         raise Unexpected_Input with "Unepxected input line """ & Line & """, cmd """ & Cmd & """";
      end if;
   end Process_Cmd;
   
   procedure Process_Dir_Result ( Line : String ) is
      Name : String := Line( Line'First+4 .. Line'Last );
   begin
      Add_Directory( Name );
   end Process_Dir_Result;
   
   procedure Process_File_Result ( Line : String ) is
      Space_Index : Natural := Index( Line, " " );
      Size_String : String := Line( Line'First .. Space_Index-1 );
      Size : Natural := Natural'Value( Size_String );
      Name : String := Line( Space_Index+1 .. Line'Last );
   begin
      Add_File( Name, Size );
   end Process_File_Result;
      
begin
   while not End_Of_File loop
      declare
         Cur_Line : String := Get_Line;
      begin
         case Cur_Line(1) is
            when '$' => Process_Cmd( Cur_Line );
            when 'd' => Process_Dir_Result( Cur_Line );
            when '0'..'9' => Process_File_Result( Cur_Line );
            when others => raise Unexpected_Input;
         end case;
      end;
   end loop;
   
   Used_Space := Total_Used_Space;
   
   Iterate_All_Directory_Sizes( Process_Directory'Access );
   
   Put_Line( Desired_Size'Image );
end Day7Part2;
