with Ada.Text_IO; use Ada.Text_IO;

procedure Day3 is
   subtype Letter is Character
     with Static_Predicate => Letter in 'A'..'Z'|'a'..'z';

   type Priority is range 0 .. Integer'Last;
   package Priority_IO is new Integer_IO(Priority);

   function Letter_Priority ( L : Letter ) return Priority is
   begin
      case L is
         when 'a'..'z' => return (Letter'Pos(L) - Letter'Pos('a'))+1;
         when 'A'..'Z' => return (Letter'Pos(L) - Letter'Pos('A'))+27;
         when others => raise Data_Error with "Can't happen";
      end case;
   end Letter_Priority;

   Total_Priority : Priority := 0;
   --Line_Number : Natural := 0;
begin
   while not End_Of_File loop
      declare
         Line : String := Get_Line;
         Half_Length : Natural := Line'Length / 2;
      begin
         --Line_Number := Line_Number + 1;
         --Put_Line( "Line number: " & Line_Number'Image );
         I_Loop: for I in Positive range 1 .. Half_Length loop
            for J in Positive range Half_Length+1 .. Line'Length loop
               if Line(I) = Line(J) then
                  Total_Priority := Total_Priority + Letter_Priority(Line(I));
                  --Put_Line( "  Match: " & I'Image & " (" & Line(I) & "), has priority: " & Letter_Priority(Line(I))'Image & ", new priority is: " & Total_Priority'Image );
                  exit I_Loop;
               end if;
            end loop;
         end loop I_Loop;
      end;
   end loop;

   Priority_IO.Put(Total_Priority);
end Day3;
