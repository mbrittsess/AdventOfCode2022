with Jets;
with Ada.Text_IO;

package body Field is

   type Rock_Index is mod 5;
   Cur_Rock_Index : Rock_Index := 0;
   Rock_Contents : array ( Rock_Index ) of Rock_Content_Access :=
     (
      new Rock_Content'
        (
         1 => "####"
        ),
      new Rock_Content'
        (
         3 => ".#.",
         2 => "###",
         1 => ".#."
        ),
      new Rock_Content'
        (
         3 => "..#",
         2 => "..#",
         1 => "###"
        ),
      new Rock_Content'
        (
         4 => "#",
         3 => "#",
         2 => "#",
         1 => "#"
        ),
      new Rock_Content'
        (
         2 => "##",
         1 => "##"
        )
     );
   
   function Get_Next_Rock_Content return Rock_Content_Access is
      Ret : Rock_Content_Access := Rock_Contents( Cur_Rock_Index );
   begin
      Cur_Rock_Index := Cur_Rock_Index + 1;
      return Ret;
   end Get_Next_Rock_Content;
   
   package Row_Vectors is new Ada.Containers.Vectors( Index_Type => Positive, Element_Type => Field_Row );
   
   Field_Backing : Row_Vectors.Vector := Row_Vectors.Empty_Vector;
   
   function Content_At ( Row, Column : Positive ) return Content is
   begin
      if Field_Backing.Is_Empty or else Field_Backing.Last_Index < Row then
         return '.';
      else
         return Field_Backing(Row)(Column);
      end if;
   end Content_At;
   
   function Highest_Level return Natural is
   begin
      if Field_Backing.Is_Empty then
         return 0;
      else
         return Field_Backing.Last_Index;
      end if;
   end Highest_Level;
   
   procedure Print_Field ( Top_Rows : Positive := 32 ) is
      use Ada.Text_IO;
   begin
      for Row in reverse Positive'Max( 1, (Highest_Level-Top_Rows)+1 ) .. Highest_Level loop
         for Col in 1 .. 7 loop
            case Content_At( Row, Col ) is
               when '.' => Put( '.' );
               when '#' => Put( '#' );
            end case;
         end loop;
         New_Line;
      end loop;
   end Print_Field;
   
   procedure Set_Content_At ( Row, Column : Positive ) is
   begin
      while Field_Backing.Is_Empty or else Field_Backing.Last_Index < Row loop
         Field_Backing.Append( "......." );
      end loop;
      declare
         Row_Contents : Field_Row := Field_Backing(Row);
      begin
         if Row_Contents(Column) /= '.' then
            raise Operation_Error;
         else
            Row_Contents(Column) := '#';
            Field_Backing(Row) := Row_Contents;
         end if;
      end;
   end Set_Content_At;
   
   Num_Rocks_Spawned : Natural := 0;
   function Get_Num_Rocks_Spawned return Natural is (Num_Rocks_Spawned);
   
   function Get_Next_Rock return Rock is
   begin
      Num_Rocks_Spawned := Num_Rocks_Spawned + 1;
      return
        (
         Pos =>
           (
            X => 3,
            Y => (if Field_Backing.Is_Empty then 4 else Field_Backing.Last_Index + 4)
           ),
         Content => Get_Next_Rock_Content
        );
   end Get_Next_Rock;
   
   procedure Add_Rock_To_Field ( R : Rock ) is
   begin
      for Rock_Row in R.Content'Range(1) loop
         for Rock_Col in R.Content'Range(2) loop
            if R.Content( Rock_Row, Rock_Col ) = '#' then
               Set_Content_At( (Rock_Row + R.Pos.Y) - 1, (Rock_Col + R.Pos.X) - 1 );
            end if;
         end loop;
      end loop;
   end Add_Rock_To_Field;
   
   procedure Try_Move_Left ( R : in out Rock ) is
      Is_At_Edge : Boolean := R.Pos.X = 1;
      Can_Move_Left : Boolean := not Is_At_Edge and then 
        (for all Y in R.Content'Range(1) => 
             (for all X in R.Content'Range(2) => R.Content(Y,X) = '.' or else Content_At( (R.Pos.Y+Y)-1, (R.Pos.X+X)-2 ) = '.'));
   begin
      if Can_Move_Left then
         R.Pos := ( X => R.Pos.X-1, Y => R.Pos.Y );
      end if;
   end Try_Move_Left;
   
   procedure Try_Move_Right ( R : in out Rock ) is
      Is_At_Edge : Boolean := ((R.Pos.X + R.Content'Last(2))-1) = Field_Row'Last;
      Can_Move_Right : Boolean := not Is_At_Edge and then
        (for all Y in R.Content'Range(1) =>
             (for all X in R.Content'Range(2) => R.Content(Y,X) = '.' or else Content_At( (R.Pos.Y+Y)-1, R.Pos.X+X ) = '.'));
   begin
      if Can_Move_Right then
         R.Pos := ( X => R.Pos.X+1, Y => R.Pos.Y );
      end if;
   end Try_Move_Right;
   
   function Can_Move_Down ( R : Rock ) return Boolean is
      Is_At_Bottom : Boolean := R.Pos.Y = 1;
   begin
      return not Is_At_Bottom and then
        (for all Y in R.Content'Range(1) =>
             (for all X in R.Content'Range(2) => R.Content(Y,X) = '.' or else Content_At( (R.Pos.Y+Y)-2, (R.Pos.X+X)-1 ) = '.'));
   end Can_Move_Down;
   
   procedure Place_Rock is
      use Ada.Text_IO;
      
      R : Rock := Get_Next_Rock;
      
      procedure Print_Field_With_Rock is
         Field_Chars : array ( 1 .. ((R.Pos.Y+R.Content'Last(1))-1), 1 .. 7 ) of Character := ( others => ( others => '.' ) );
      begin
         -- Fill in existing parts of field.
         for Row in 1 .. Highest_Level loop
            for Col in 1 .. 7 loop
               if Content_At( Row, Col ) = '#' then
                  Field_Chars( Row, Col ) := '#';
               end if;
            end loop;
         end loop;
         
         -- Fill in parts of rock
         for Rock_Row in R.Content'Range(1) loop
            for Rock_Col in R.Content'Range(2) loop
               if R.Content(Rock_Row,Rock_Col) = '#' then
                  Field_Chars( (R.Pos.Y+Rock_Row)-1, (R.Pos.X+Rock_Col)-1 ) := '@';
               end if;
            end loop;
         end loop;
         
         -- Print what's been gathered
         for Row in reverse Field_Chars'Range(1) loop
            for Col in Field_Chars'Range(2) loop
               Put( Field_Chars( Row, Col ) );
            end loop;
            New_Line;
         end loop;
      end Print_Field_With_Rock;
   begin
      --Put_Line( "When rock spawns:" ); Print_Field_With_Rock;
      loop
         case Jets.Get_Jet_Direction is
            when Jets.Left => Try_Move_Left( R ); --Put_Line( "Rock moved left:" ); Print_Field_With_Rock;
            when Jets.Right => Try_Move_Right( R ); --Put_Line( "Rock moved right:" ); Print_Field_With_Rock;
         end case;
         if Can_Move_Down( R ) then
            R.Pos := ( X => R.Pos.X, Y => R.Pos.Y-1 ); --Put_Line( "Rock moved down:" ); Print_Field_With_Rock;
         else
            Add_Rock_To_Field( R ); --Put_Line( "Rock came to rest:" ); Print_Field; -- Not Print_Field_With_Rock
            exit;
         end if;
      end loop;
   end Place_Rock;

end Field;
