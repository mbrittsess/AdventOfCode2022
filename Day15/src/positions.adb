package body Positions is

   function To_String ( P : Position ) return String is
   begin
      return "(" & P.X'Image & "," & P.Y'Image & ")";
   end To_String;
   
   function "+" ( Left, Right : Position ) return Position is
   begin
      return ( Left.X+Right.X, Left.Y+Right.Y );
   end "+";
   
   function "-" ( Left, Right : Position ) return Position is
   begin
      return ( Left.X-Right.X, Left.Y-Right.Y );
   end "-";
   
   -- Manhattan distance
   function "abs" ( P : Position ) return Integer is
   begin
      return (abs P.X) + (abs P.Y);
   end "abs";
   
   function Make_Horiz_Range ( A, B : Position ) return Position_Sequence is
      Step : Integer := (if A.X < B.X then 1 else -1);
      function Recurse ( Accum : Position_Sequence; X : Integer ) return Position_Sequence is
         Cumulative : Position_Sequence := Accum & Position'( X => X, Y => A.Y );
      begin
         if X = B.X then
            return Cumulative;
         else
            return Recurse( Cumulative, X+Step );
         end if;
      end Recurse;
      Start : Position_Sequence( 2 .. 1 );
   begin
      return Recurse( Start, A.X );
   end Make_Horiz_Range;
   
   function Make_Vert_Range ( A, B : Position ) return Position_Sequence is
      Step : Integer := (if A.Y < B.Y then 1 else -1);
      function Recurse ( Accum : Position_Sequence; Y : Integer ) return Position_Sequence is
         Cumulative : Position_Sequence := Accum & Position'( X => A.X, Y => Y );
      begin
         if Y = B.Y then
            return Cumulative;
         else
            return Recurse( Cumulative, Y+Step );
         end if;
      end Recurse;
      Start : Position_Sequence( 2 .. 1 );
   begin
      return Recurse( Start, A.Y );
   end Make_Vert_Range;
   
   function Make_Range ( From, To : Position ) return Position_Sequence is
   begin
      if From.X = To.X then
         return Make_Vert_Range( From, To );
      else
         return Make_Horiz_Range( From, To );
      end if;
   end Make_Range;
   
end Positions;
