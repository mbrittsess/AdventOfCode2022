package Positions is

   type Position is 
      record
         X, Y : Integer;
      end record;
   
   function To_String ( P : Position ) return String;
   function "+" ( Left, Right : Position ) return Position;
   
   type Position_Sequence is array ( Positive range <> ) of Position;
   function Make_Range ( From, To : Position ) return Position_Sequence
     with Pre => (From.X = To.X) or (From.Y = To.Y);

end Positions;
