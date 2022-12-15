with Data_Elements;

package Packets is

   type Packet_Sequence is array ( Positive range <> ) of Data_Elements.Data_Element_Access;
   subtype Pair is Packet_Sequence( 1 .. 2 );
   type Pair_Sequence is array ( Positive range <> ) of Pair;
   
   function All_Packets return Pair_Sequence;
   function All_Packets return Packet_Sequence;
   
   function Dividers return Pair;
   
private
   
   function Read_Pair return Pair;
   function Read_All return Pair_Sequence;
   function Read_All ( Accum : Pair_Sequence ) return Pair_Sequence;

end Packets;
