with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure Day10 is
   procedure Inc ( I : in out Integer; Amt : Integer := 1 ) is
   begin
      I := I + Amt;
   end Inc;

   --type CPU is
   --   record
   --      Cycles : Natural := 0;
   --      X : Integer := 1;
   --   end record;
   --State : CPU := ( others => <> );
   Cycles : Natural := 0;
   X : Integer := 1;

   function Signal_Strength return Integer is (Cycles * X);

   Signal_Sum : Integer := 0;
   procedure Cycle_Event is
   begin
      --Put_Line( " CycleEvent at cycle " & Cycles'Image );
      if Cycles in 20|60|100|140|180|220 then
         Inc( Signal_Sum, Signal_Strength );
         --Put_Line( "Cycle #" & Cycles'Image & ", Signal Strength " & Signal_Strength'Image & ", Cum. Signal Strength " & Signal_Sum'Image );
      end if;
   end Cycle_Event;

   procedure Inc_Cycle is
   begin
      Cycles := Cycles + 1;
      Cycle_Event;
   end Inc_Cycle;

   type Instruction is ( noop, addx );

   type Access_Do_Instruction is not null access procedure ( Arg_Str : String );

   procedure Do_Noop ( Arg_Str : String ) with Pre => Arg_Str = "" is
   begin
      --Put_Line( "Performing noop after cycle " & Cycles'Image );
      --Inc( State.Cycles );
      --State.Cycles := State.Cycles + 1;
      Inc_Cycle;
      --Put_Line ( " then " & Cycles'Image );
      --Cycle_Event;
   end Do_Noop;

   procedure Do_Addx ( Arg_Str : String ) is
      Operand : Integer := Integer'Value( Arg_Str );
   begin
      --Put_Line( "Performing addx " & Arg_Str & " after cycle " & Cycles'Image );
      --Inc( State.Cycles );
      --State.Cycles := State.Cycles + 1;
      Inc_Cycle;
      --Put_Line ( " then " & Cycles'Image );
      --Cycle_Event;
      --Inc( State.Cycles );
      --State.Cycles := State.Cycles + 1;
      Inc_Cycle;
      --Put_Line ( " then " & Cycles'Image );
      --Cycle_Event;
      --Inc( State.X, Operand );
      X := X + Operand;
   end Do_Addx;

   Instruction_Dispatch : array( Instruction ) of Access_Do_Instruction :=
     (
      noop => Do_Noop'Access,
      addx => Do_Addx'Access
     );

   procedure Parse ( Line : String ) is
      First_Space_Idx : Natural := Index( Line, " " );
      End_Cmd_Idx : Positive := (if First_Space_Idx /= 0 then First_Space_Idx-1 else Line'Last);
      Cmd_Str : String := Line( Line'First .. End_Cmd_Idx );
      Arg_Str : String := Line( End_Cmd_Idx+2 .. Line'Last );
      Cmd : Instruction := Instruction'Value( Cmd_Str );
   begin
      Instruction_Dispatch(Cmd)( Arg_Str );
   end Parse;

begin
   while not End_Of_File loop
      Parse( Get_Line );
   end loop;
   Put_Line( Signal_Sum'Image );
end Day10;
