with Part1Runners; use Part1Runners;
with Ada.Text_IO; use Ada.Text_IO;

procedure Day19 is
begin
   declare
      Runners : array( 1 .. 6 ) of Runner;
   begin
      null;
   end;

   Put_Line( " Total Quality: " & Natural'Image( Coordinator.Final_Result) );
end Day19;
