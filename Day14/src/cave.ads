with Positions; use Positions;

package Cave is

   subtype X_Coord is Integer range 492 .. 551;
   subtype Y_Coord is Integer range 0 .. 177;
   
   type Content is ( Air, Rock, Sand );

end Cave;
