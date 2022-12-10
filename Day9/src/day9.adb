with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;

procedure Day9 is

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

   type Eight_Positions is array( 1 .. 8 ) of Position;
   function Adjacent_Positions ( P : Position ) return Eight_Positions is
      Path : constant array( 1 .. 8 ) of Direction := ( U, R, D, D, L, L, U, U );
      Ret : Eight_Positions;
      New_Pos : Position := P;
   begin
      for I in Ret'Range loop
         New_Pos := New_Pos + Offsets( Path( I ) );
         Ret(I) := New_Pos;
      end loop;
      return Ret;
   end Adjacent_Positions;

   function Get_Both_Adjacent_Position ( A, B : Position ) return Position is
      AdjA : Eight_Positions := Adjacent_Positions( A );
      AdjB : Eight_Positions := Adjacent_Positions( B );
   begin
      for AI in Eight_Positions'Range loop
         for BI in AI .. Eight_Positions'Last loop
            if AdjA(AI) = AdjB(BI) then
               return AdjA(AI);
            end if;
         end loop;
      end loop;
      raise Cant_Happen with To_String(A) & " " & To_String(B);
   end Get_Both_Adjacent_Position;

   Head, Tail : Position := ( 0, 0 );

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
            if not Are_Adjacent( Head, Tail ) then
               Tail := Tail + ( Clamp( Head.X-Tail.X ), Clamp( Head.Y-Tail.Y ) );
               Tail_Log.Append( Tail );
            end if;
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

end Day9;
