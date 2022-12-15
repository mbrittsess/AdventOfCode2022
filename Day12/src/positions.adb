package body Positions is

   function Get_Adjacent_Positions ( P : Position ) return Adjacent_Positions is
      Ret : Adjacent_Positions( 1 .. 4 );
      Num : Natural := 0;
      X_Offsets : array ( 1 .. 4 ) of Integer := ( 0, 1, 0, -1 ); --Clockwise from top
      Y_Offsets : array ( 1 .. 4 ) of Integer := ( 1, 0, -1, 0 ); --Clockwise from top
   begin
      for Ofs_Idx in 1 .. 4 loop
         declare
            New_X : Integer := Integer(P.X) + X_Offsets(Ofs_Idx);
            New_Y : Integer := Integer(P.Y) + Y_Offsets(Ofs_Idx);
         begin
            if New_X in Integer(X_Coord'First) .. Integer(X_Coord'Last)
              and then New_Y in Integer(Y_Coord'First) .. Integer(Y_Coord'Last)
            then
               Num := Num + 1;
               Ret( Num ) := ( X_Coord(New_X), Y_Coord(New_Y) );
            end if;
         end;
      end loop;
      return Ret( 1 .. Num );
   end Get_Adjacent_Positions;

   function To_String ( P : Position ) return String is
   begin
      return "(" & P.X'Image & "," & P.Y'Image & ")";
   end To_String;

end Positions;
