with Part2Runners; use Part2Runners;
with Blueprints; use Blueprints;
with Ada.Text_IO; use Ada.Text_IO;

procedure Day19Part2 is
begin
   declare
      Runners : array( 1 .. 3 ) of Runner;
   begin
      null;
   end;
   
   Put_Line( "Geodes multiplied: " & Long_Long_Integer'Image( Coordinator.Final_Result) );
end Day19Part2;
