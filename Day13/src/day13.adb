with Ada.Text_IO; use Ada.Text_IO;
with Data_Elements; use Data_Elements;
with Packets; use Packets;

procedure Day13 is
   All_Pairs : Pair_Sequence := All_Packets;
   Sum : Natural := 0;
begin
   for Idx in All_Pairs'Range loop
      declare
         This_Pair : Pair := All_Pairs(Idx);
      begin
         if This_Pair(1) < This_Pair(2) then
            Sum := Sum + Idx;
         end if;
      end;
   end loop;
   Put_Line( Sum'Image );
end Day13;
