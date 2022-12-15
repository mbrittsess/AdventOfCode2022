with Ada.Text_IO; use Ada.Text_IO;
with Data_Elements; use Data_Elements;
with Packets; use Packets;
with Ada.Containers.Generic_Array_Sort;

procedure Day13Part2 is
   Markers : Packet_Sequence := Dividers;
   Packets : Packet_Sequence := All_Packets & Markers;
   procedure Packet_Sort is new Ada.Containers.Generic_Array_Sort( Positive, Data_Element_Access, Packet_Sequence );
   Mul_Sum : Natural := 1;
begin
   Packet_Sort( Packets );
   for Idx in Packets'Range loop
      declare
         Data : Data_Element_Access := Packets(Idx);
      begin
         if Data = Markers(1) or else Data = Markers(2) then
            Mul_Sum := Mul_Sum * Idx;
         end if;
      end;
   end loop;
   
   Put_Line( Mul_Sum'Image );
end Day13Part2;
