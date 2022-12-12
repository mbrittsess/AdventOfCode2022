with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure Day10Part2 is
   procedure Inc ( I : in out Integer; Amt : Integer := 1 ) is
   begin
      I := I + Amt;
   end Inc;
   
   -- Originally had a record but it wouldn't update correctly
   Cycles : Natural := 0;
   X : Integer := 1;
   
   function Signal_Strength return Integer is (Cycles * X);
   
   CRT_Buffer : array( 0 .. 39, 0 .. 5 ) of Character := ( others => ( others =>' ' ) );
   
   procedure Cycle_Event is
      Col : Natural := (Cycles-1) mod CRT_Buffer'Length(1);
      Row : Natural := (Cycles-1) / CRT_Buffer'Length(1);
      Sprite_Pos : Integer := X;
   begin
      if (abs (Col-X)) <= 1 then
         CRT_Buffer(Col,Row) := '#';
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
      Inc_Cycle;
   end Do_Noop;
   
   procedure Do_Addx ( Arg_Str : String ) is
      Operand : Integer := Integer'Value( Arg_Str );
   begin
      Inc_Cycle;
      Inc_Cycle;
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
   
   for Row in CRT_Buffer'Range(2) loop
      for Col in CRT_Buffer'Range(1) loop
         Put( CRT_Buffer( Col, Row ) );
      end loop;
      New_Line;   
   end loop;
end Day10Part2;
