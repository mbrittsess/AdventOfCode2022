with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure Day18 is
   -- Coordinates span from 0 to 21
   Space : array ( -1 .. 22, -1 .. 22, -1 .. 22 ) of Boolean := ( others => ( others => ( others => False ) ) );
begin
   -- Fill with scan
   while not End_Of_File loop
      declare
         Line : String := Get_Line;
         First_Comma_Idx : Natural := Index( Line, "," );
         Second_Comma_Idx : Natural := Index( Line, ",", First_Comma_Idx+1 );
         First : Integer := Integer'Value( Line( Line'First .. First_Comma_Idx-1 ) );
         Second : Integer := Integer'Value( Line( First_Comma_Idx+1 .. Second_Comma_Idx-1 ) );
         Third : Integer := Integer'Value( Line( Second_Comma_Idx+1 .. Line'Last ) );
      begin
         Space( First, Second, Third ) := True;
      end;
   end loop;

   declare
      Area : Integer := 0;
      procedure Increment is
      begin
         Area := Area + 1;
      end Increment;
   begin
      for X in Space'First(1)+1 .. Space'Last(1)-1 loop
         for Y in Space'First(2)+1 .. Space'Last(2)-1 loop
            for Z in Space'first(3)+1 .. Space'Last(3)-1 loop
               if Space(X,Y,Z) then
                  if not Space(X+1,Y,Z) then Increment; end if;
                  if not Space(X-1,Y,Z) then Increment; end if;
                  if not Space(X,Y+1,Z) then Increment; end if;
                  if not Space(X,Y-1,Z) then Increment; end if;
                  if not Space(X,Y,Z+1) then Increment; end if;
                  if not Space(X,Y,Z-1) then Increment; end if;
               end if;
            end loop;
         end loop;
      end loop;
      Put_Line( "Area: " & Area'Image );
   end;

end Day18;
