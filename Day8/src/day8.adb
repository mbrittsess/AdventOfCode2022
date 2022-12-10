with Ada.Text_IO; use Ada.Text_IO;

procedure Day8 is
   type Tree_Info is
      record
         Visible : Boolean := False;
         Height : Natural;
      end record;

   Row_Span : constant := 99;
   Col_Span : constant := 99;

   Forest : array( 1 .. 99, 1 .. 99 ) of Tree_Info;

   procedure Check_Tree ( Tallest_Yet : in out Integer; Info : in out Tree_Info ) is
      Tree_Height : Natural := Info.Height;
   begin
      if Tree_Height > Tallest_Yet then
         Tallest_Yet := Tree_Height;
         Info.Visible := True;
      end if;
   end Check_Tree;

begin
   -- Initialize the forest
   for Y in Forest'Range(2) loop
      declare
         Line : String := Get_Line;
      begin
         for X in Forest'Range(1) loop
            Forest(X,Y).Height := Natural'Value( Line(X..X) );
         end loop;
      end;
   end loop;

   -- Check the forest row-by-row, left-to-right and right-to-left
   for Y in Forest'Range(2) loop
      declare
         Tallest_Yet : Integer := -1;
      begin
         for X in Forest'Range(1) loop
            Check_Tree( Tallest_Yet, Forest(X,Y) ); --in out, in out
         end loop;
         Tallest_Yet := -1;
         for X in reverse Forest'Range(1) loop
            Check_Tree( Tallest_Yet, Forest(X,Y) ); --in out, in out
         end loop;
      end;
   end loop;

   -- Check the forest column-by-column, top-to-bottom and bottom-to-top
   for X in Forest'Range(1) loop
      declare
         Tallest_Yet : Integer := -1;
      begin
         for Y in Forest'Range(2) loop
            Check_Tree( Tallest_Yet, Forest(X,Y) ); --in out, in out
         end loop;
         Tallest_Yet := -1;
         for Y in reverse Forest'Range(2) loop
            Check_Tree( Tallest_Yet, Forest(X,Y) ); --in out, in out
         end loop;
      end;
   end loop;

   --Count up how many trees are visible
   declare
      Total_Visible : Natural := 0;
   begin
      for Info : Tree_Info of Forest loop
         if Info.Visible then
            Total_Visible := Total_Visible + 1;
         end if;
      end loop;
      Put_Line( Total_Visible'Image );
   end;

end Day8;
