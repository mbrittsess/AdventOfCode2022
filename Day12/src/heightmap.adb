with Fields;
with Ada.Text_IO; use Ada.Text_IO;

package body Heightmap is

   package Height_Fields is new Fields( Element_Type => Height );
   
   function Field_Height ( X : X_Coord; Y : Y_Coord ) return Height is (Height_Fields.Field(X,Y));
   
   subtype Lower_Alpha is Character range 'a' .. 'z';
   function To_Height ( C : Lower_Alpha ) return Height is (Character'Pos(C)-Character'Pos('a'));
   
begin
   
   for Y in Y_Coord loop
      declare
         Line : String := Get_Line;
      begin
         for X in X_Coord loop
            declare
               C : Character := Line(Integer(X)+1);
               P : Position := ( X, Y );
            begin
               case C is
                  when 'a' .. 'z' => Height_Fields.Field(P) := To_Height(C);
                  when 'S' => Height_Fields.Field(P) := To_Height('a'); Start := P;
                  when 'E' => Height_Fields.Field(P) := To_Height('z'); Goal := P;
                  when others => raise Initialization_Error;
               end case;
            end;
         end loop;
      end;
   end loop;

end Heightmap;
