package body Positions is

   function Get_Adjacent_Positions ( P : Position ) return Adjacent_Positions is
      Ret : Adjacent_Positions( 1 .. 8 );
      Num : Natural := 0;
   begin
      for X_Ofs in -1 .. 1 loop
         for Y_Ofs in -1 .. 1 loop
            declare
               NewX : Integer := Integer(P.X) + X_Ofs;
               NewY : Integer := Integer(P.Y) + Y_Ofs;
            begin
               if NewX in Integer(X_Coord'First) .. Integer(X_Coord'Last)
                 and then NewY in Integer(Y_Coord'First) .. Integer(Y_Coord'Last)
                 and then not ( X_Ofs = 0 and Y_Ofs = 0 )
               then
                  Num := Num + 1;
                  Ret(Num) := ( X_Coord(NewX), Y_Coord(NewY) );
               end if;
            end;
         end loop;
      end loop;
      return Ret( 1 .. Num );
   end Get_Adjacent_Positions;

end Positions;
