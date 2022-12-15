with Data_Elements;

package Packets is

   type Pair is array ( Positive range 1 .. 2 ) of Data_Elements.Data_Element_Access;
   type Pair_Sequence is array ( Positive range <> ) of Pair;
   
   function All_Packets return Pair_Sequence;
   
private
   
   function Read_Pair return Pair;
   function Read_All return Pair_Sequence;
   function Read_All ( Accum : Pair_Sequence ) return Pair_Sequence;

end Packets;
