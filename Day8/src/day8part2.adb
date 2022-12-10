with Ada.Text_IO; use Ada.Text_IO;

procedure Day8Part2 is
   
   Cant_Happen : exception;
   
   type Tree_Info is
      record
         Visible : Boolean := False;
         Height : Natural;
      end record;
   
   Row_Span : constant := 99;
   Col_Span : constant := 99;
   
   subtype Row_Idx is Integer range 1 .. Row_Span;
   subtype Col_Idx is Integer range 1 .. Col_Span;
   
   Forest : array( Row_Idx, Col_Idx ) of Tree_Info;
   
   subtype Step_Amount is Integer range -1..1;
   
   function Viewing_Distance
     (
      X : Col_Idx;
      Y : Row_Idx;
      XOfs, YOfs : Step_Amount := 0 
     ) return Natural is
      Score : Natural := 0;
      Own_Height : Natural := Forest(X,Y).Height;
      New_X : Integer := X + XOfs;
      New_Y : Integer := Y + YOfs;
   begin
      while New_X in Col_Idx and then New_Y in Row_Idx loop
         Score := Score + 1;
         if Forest(New_X,New_Y).Height >= Own_Height then
            exit;
         end if;
         New_X := New_X + XOfs;
         New_Y := New_Y + YOfs;
      end loop;
      return Score;
   end Viewing_Distance;
   
   function Scenic_Score ( X : Col_Idx; Y : Row_Idx ) return Natural is
   begin
      return Viewing_Distance(X,Y,-1,0)
        * Viewing_Distance(X,Y,+1,0)
        * Viewing_Distance(X,Y,0,-1)
        * Viewing_Distance(X,Y,0,+1);
   end Scenic_Score;
   
   Highest_Score : Natural := 0;
begin
   -- Initialize the forest
   for Y in Row_Idx loop
      declare
         Line : String := Get_Line;
      begin
         for X in Col_Idx loop
            Forest(X,Y).Height := Natural'Value( Line(X..X) );
         end loop;
      end;
   end loop;
   
   -- Now scan it for the most scenic tree
   for Y in Row_Idx loop
      for X in Col_Idx loop
         Highest_Score := Natural'Max( Highest_Score, Scenic_Score(X,Y) );
      end loop;
   end loop;
   
   Put_Line( Highest_Score'Image );
   
end Day8Part2;
