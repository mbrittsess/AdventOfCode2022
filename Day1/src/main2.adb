with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;

procedure Main2 is
   package Int_Vectors is new Ada.Containers.Vectors( Positive, Integer );
   package Int_Vectors_Sort is new Int_Vectors.Generic_Sorting;

   Per_Elf_Totals : Int_Vectors.Vector := Int_Vectors.Empty_Vector;
   Current_Total : Integer := 0;

   procedure Flush_Total is
   begin
      if Current_Total /= 0 then
         Per_Elf_Totals.Append(Current_Total);
         Current_Total := 0;
      end if;
   end Flush_Total;
begin
   --Start by building up list of calorie totals
   while not End_Of_File loop
      declare
         Line : String := Get_Line;
      begin
         if Line'Length = 0 then
            Flush_Total;
         else
            Current_Total := Current_Total + Integer'Value(Line);
         end if;
      end;
   end loop;
   Flush_Total;

   --Then sort the list
   Int_Vectors_Sort.Sort( Per_Elf_Totals );

   --Now sum the last three and print that
   declare
      Top_Three_Total : Integer := 0;
   begin
      for Idx in Per_Elf_Totals.Last_Index-2 .. Per_Elf_Totals.Last_Index loop
         Top_Three_Total := Top_Three_Total + Per_Elf_Totals.Element(Idx);
      end loop;
      Put_Line( Top_Three_Total'Image );
   end;
end Main2;
