with Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   package Int_IO renames Ada.Integer_Text_IO;

   Most_Total_Calories : Integer := 0;
   Current_Total : Integer := 0;

   procedure Flush_Max is
   begin
      Most_Total_Calories := Integer'Max( Most_Total_Calories, Current_Total );
      Current_Total := 0;
   end Flush_Max;
begin
   while not End_Of_File loop
      declare
         Line : String := Get_Line;
      begin
         if Line'Length = 0 then
            Flush_Max;
         else
            Current_Total := Current_Total + Integer'Value(Line);
         end if;
      end;
   end loop;
   Flush_Max;
   Int_IO.Put( Most_Total_Calories );
end Main;
