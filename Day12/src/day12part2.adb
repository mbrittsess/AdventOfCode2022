with Heightmap; use Heightmap;
with Positions; use Positions;
with Fields;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;

procedure Day12Part2 is
   Cant_Happen : exception;
   
   subtype Path_Length is Natural;
   package Distances_Field is new Fields( Element_Type => Path_Length );
   package Explored_Field is new Fields( Element_Type => Boolean );
   package Previous_Field is new Fields( Element_Type => Position );
   function Distances ( P : Position ) return Distances_Field.Accessor renames Distances_Field.Field;
   function Explored ( P : Position ) return Explored_Field.Accessor renames Explored_Field.Field;
   function Previous ( P : Position ) return Previous_Field.Accessor renames Previous_Field.Field;
   package Position_Vectors is new Ada.Containers.Vectors( Index_Type => Positive, Element_Type => Position );
   
   function Shortest_Route_Length ( This_Start : Position ) return Natural is
      Queue : Position_Vectors.Vector := Position_Vectors.Empty_Vector;
      function Dequeue return Position is
         Ret : Position := Queue.First_Element;
      begin
         Queue.Delete_First;
         return Ret;
      end Dequeue;
   begin
      Explored_Field.Fill_All( False );
      Queue.Append( This_Start );
      Distances( This_Start ) := 0;
      Explored( This_Start ) := True;
      while not Queue.Is_Empty loop
         declare
            Own_Pos : Position := Dequeue;
            Own_Steps : Path_Length := Distances(Own_Pos);
            New_Adj_Steps : Path_Length := Own_Steps+1;
            Own_Height : Height := Field_Height(Own_Pos);
            Height_Limit : Height := Own_Height+1;
         begin
            if Own_Pos = Goal then
               return Own_Steps;
            end if;
            for Adj_Pos of Get_Adjacent_Positions( Own_Pos ) loop
               if (not Explored(Adj_Pos)) and then (Field_Height(Adj_Pos) <= Height_Limit) then
                  Queue.Append(Adj_Pos);
                  Explored(Adj_Pos) := True;
                  Distances(Adj_Pos) := New_Adj_Steps;
                  Previous(Adj_Pos) := Own_Pos;
               end if;
            end loop;
         end;
      end loop;
   
      return Path_Length'Last;
   end Shortest_Route_Length;
begin
   declare
      Shortest_Path : Path_Length := Path_Length'Last;
   begin
      for Y in Y_Coord loop
         for X in X_Coord loop
            declare
               Pos : Position := ( X, Y );
            begin
               if Field_Height(Pos) = 0 then
                  Shortest_Path := Path_Length'Min( Shortest_Path, Shortest_Route_Length(Pos) );
               end if;
            end;
         end loop;
      end loop;
      Put_Line( Shortest_Path'Image );
   end;
end Day12Part2;
