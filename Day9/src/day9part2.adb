with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;

procedure Day9Part2 is
   
   Cant_Happen : exception;
   
   type Position is
      record
         X, Y : Integer;
      end record;
   
   function "=" ( Left, Right : Position ) return Boolean is (Left.X = Right.X and then Left.Y = Right.Y);
   -- Basic sorting operator, sort first by X and then by Y
   function "<" ( Left, Right : Position ) return Boolean is (if Left.X /= Right.X then Left.X < Right.X else Left.Y < Right.Y);
   
   function To_String ( P : Position ) return String is
   begin
      return "(" & P.X'Image & "," & P.Y'Image & ")";
   end To_String;
   
   function Are_Adjacent ( A, B : Position ) return Boolean is
   begin
      return Integer'Max( abs ( A.X - B.X ), abs ( A.Y - B.Y ) ) <= 1;
   end Are_Adjacent;
   
   package Tail_Vectors is new Ada.Containers.Vectors( Positive, Position );
   use Tail_Vectors;
   
   package Tail_Vector_Sorting is new Tail_Vectors.Generic_Sorting;
   
   type Offset is new Position;
   
   function "+" ( Left : Position; Right : Offset ) return Position is (Left.X+Right.X, Left.Y+Right.Y);
   
   type Direction is ( U, R, D, L );
   
   Offsets : array( Direction ) of Offset :=
     (
      U => ( 0, 1 ),
      R => ( 1, 0 ),
      D => ( 0, -1 ),
      L => ( -1, 0 )
     );
   
   Knots : array ( 1 .. 10 ) of Position :=( others => ( 0, 0 ) );
   Head : Position renames Knots(Knots'First);
   Tail : Position renames Knots(Knots'Last);
   
   Tail_Log : Vector := Empty_Vector & Tail;

   function Clamp ( X : Integer ) return Integer is
   begin
      if X > 1 then
         return 1;
      elsif X < -1 then
         return -1;
      else
         return X;
      end if;
   end Clamp;
   
   Number_Of_Locations : Natural := 0;
   
   procedure Update ( A, B : in out Position ) is
   begin
      if not Are_Adjacent( A, B ) then
         B := B + ( Clamp( A.X-B.X ), Clamp( A.Y-B.Y ) );
      end if;
   end Update;
   
begin
   while not End_Of_File loop
      declare
         Line : String := Get_Line;
         Dir : Direction := Direction'Value( Line(Line'First .. Line'First) );
         Ofs : Offset := Offsets( Dir );
         Times : Natural := Natural'Value( Line(Line'First+2 .. Line'Last) );
      begin
         for T in 1 .. Times loop
            Head := Head + Ofs;
            for I in Knots'First .. Knots'Last-1 loop
               Update( Knots(I), Knots(I+1) );
            end loop;
            Tail_Log.Append( Tail );
         end loop;
      end;
   end loop;
   
   Tail_Vector_Sorting.Sort( Tail_Log );
   
   Number_Of_Locations := 1;
   for I in Tail_Log.First_Index+1 .. Tail_Log.Last_Index loop
      if Tail_Log.Element(I) /= Tail_Log.Element(I-1) then
         Number_Of_Locations := Number_Of_Locations + 1;
      end if;
   end loop;
   
   Put_Line( Number_Of_Locations'Image );
   
end Day9Part2;
