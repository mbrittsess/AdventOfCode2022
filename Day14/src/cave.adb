with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings; use Ada.Strings;

package body Cave is

   procedure Add_Floor is
      function Highest_Y return Integer is
      begin
         for Y in reverse Y_Coord loop
            for X in X_Coord loop
               if Cave(X,Y) /= Air then
                  return Y;
               end if;
            end loop;
         end loop;
         raise Cant_Happen;
      end Highest_Y;

      Y : Integer := Highest_Y + 2;
   begin
      for X in X_Coord loop
         Cave( X, Y ) := Rock;
      end loop;
   end Add_Floor;

   procedure Run_Sand_Simulation is
      Offsets : array( 1 .. 3 ) of Position := ( (0,1), (-1,1), (1,1) );
   begin
      Top_Level: loop
         declare
            Pos : Position := ( 500, 0 );
            function In_Bounds ( P : Position ) return Boolean is (P.X in Integer(X_Coord'First) .. Integer(X_Coord'Last) and P.Y in Integer(Y_Coord'First) .. Integer(Y_Coord'Last));
         begin
            Sand_Loop: loop
               declare
                  Blocked : Boolean := True;
               begin
                  Ofs_Loop: for Ofs of Offsets loop
                     declare
                        New_Pos : Position := Pos + Ofs;
                     begin
                        if not In_Bounds( New_Pos ) then
                           return;
                        elsif Cave( New_Pos ) = Air then
                           Pos := New_Pos;
                           Blocked := False;
                           exit Ofs_Loop;
                        end if;
                     end;
                  end loop Ofs_Loop;
                  if Blocked then
                     --Settle into position
                     Cave( Pos ) := Sand;
                     if Pos = ( 500, 0 ) then
                        return;
                     else
                        exit Sand_Loop;
                     end if;
                  end if;
               end;
            end loop Sand_Loop;
         end;
      end loop Top_Level;
   end Run_Sand_Simulation;

begin
   while not End_Of_File loop
      declare
         Line : String := Get_Line;
         Comma_Idx : Natural := Index( Line, "," );
         First : Boolean := True;
         Prev_Pos : Position := ( 0, 0 );
      begin
         while Comma_Idx /= 0 loop
            declare
               function Or_Last ( Idx : Natural ) return Positive is (if Idx = 0 then (Line'Last)+1 else Idx);
               First_Bound : Positive := Index( Line, " ", Comma_Idx-1, Backward )+1;
               Second_Bound : Positive := Or_Last(Index( Line, " ", Comma_Idx+1 ))-1;
               First_Num_Str : String := Line( First_Bound .. Comma_Idx-1 );
               Second_Num_Str : String := Line( Comma_Idx+1 .. Second_Bound );
               First_Num : Integer := Integer'Value( First_Num_Str );
               Second_Num : Integer := Integer'Value( Second_Num_Str );
               Cur_Pos : Position := ( First_Num, Second_Num );
            begin
               if not First then
                  for Pos of Make_Range( Prev_Pos, Cur_Pos ) loop
                     Cave( Pos ) := Rock;
                  end loop;
               end if;
               Prev_Pos := Cur_Pos;
               First := False;
               Comma_Idx := Index( Line, ",", Comma_Idx+1 );
            end;
         end loop;
      end;
   end loop;
end Cave;
