with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;

procedure Day18Part2 is
   type Content_Kind is ( Air, Lava );
   type Direction is ( Forward, Backward, Left, Right, Up, Down );
   Opposite_Direction : array ( Direction ) of Direction :=
     (
      Forward => Backward,
      Backward => Forward,
      Left => Right,
      Right => Left,
      Up => Down,
      Down => Up
     );
   type Exposed_Record is array ( Direction ) of Boolean;
   
   Min : constant := -2;
   Max : constant := 23;
   
   function Within_Bounds ( X, Y, Z : Integer ) return Boolean is ((X in Min+1..Max-1) and (Y in Min+1..Max-1) and (Z in Min+1..Max-1));
   procedure Get_Adjacent ( X, Y, Z : in out Integer; Dir : Direction ) is
   begin
      case Dir is
         when Forward => X := X + 1;
         when Backward => X := X - 1;
         when Left => Y := Y + 1;
         when Right => Y := Y - 1;
         when Up => Z := Z + 1;
         when Down => Z := Z - 1;
      end case;
   end Get_Adjacent;
   
   Content : array ( Min .. Max, Min .. Max, Min .. Max ) of Content_Kind := ( others => ( others => ( others => Air ) ) );
   Visited : array ( Min .. Max, Min .. Max, Min .. Max ) of Boolean := ( others => ( others => ( others => False ) ) );
   Exposed_Records : array ( Min .. Max, Min .. Max, Min .. Max ) of Exposed_Record := ( others => ( others => ( others => ( others => False ) ) ) );
   
   procedure Visit ( X, Y, Z : Integer ) is
   begin
      --Put_Line( "Visiting (" & X'Image & "," & Y'Image & "," & Z'Image & ")" );
      Visited( X, Y, Z ) := True;
      for Dir in Direction loop
         declare
            AdjX : Integer := X;
            AdjY : Integer := Y;
            AdjZ : Integer := Z;
         begin
            Get_Adjacent( AdjX, AdjY, AdjZ, Dir ); -- in out, in out, in out, in
            if Within_Bounds( AdjX, AdjY, AdjZ ) then
               if Content( AdjX, AdjY, AdjZ ) = Lava then
                  Exposed_Records( AdjX, AdjY, AdjZ )( Opposite_Direction( Dir ) ) := True;
               elsif Content( AdjX, AdjY, AdjZ ) = Air and then not Visited( AdjX, AdjY, AdjZ ) then
                  Visit( AdjX, AdjY, AdjZ );
               end if;
            end if;
         end;
      end loop;
   end Visit;
begin
   -- Fill with scan data
   while not End_Of_File loop
      declare
         use Ada.Strings.Fixed;
         
         Line : String := Get_Line;
         First_Comma_Idx : Natural := Index( Line, "," );
         Second_Comma_Idx : Natural := Index( Line, ",", First_Comma_Idx+1 );
         First : Integer := Integer'Value( Line( Line'First .. First_Comma_Idx-1 ) );
         Second : Integer := Integer'Value( Line( First_Comma_Idx+1 .. Second_Comma_Idx-1 ) );
         Third : Integer := Integer'Value( Line( Second_Comma_Idx+1 .. Line'Last ) );
      begin
         Content( First, Second, Third ) := Lava;
      end;
   end loop;
   
   --Visit all externally-accessible air
   Visit( Min+1, Min+1, Min+1 );
   
   --Count how many exposed faces there are
   declare
      Area : Integer := 0;
      procedure Increment is
      begin
         Area := Area + 1;
      end Increment;
   begin
      for Rec of Exposed_Records loop
         for Dir in Direction loop
            if Rec(Dir) then
               Increment;
            end if;
         end loop;
      end loop;
      Put_Line( Area'Image );
   end;
end Day18Part2;
