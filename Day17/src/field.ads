with Ada.Containers.Vectors;
with Positions; use Positions;

package Field is
   
   Operation_Error : exception;

   type Content is ( '.', '#' );
   
   type Rock_Content is array ( Positive range <>, Positive range <> ) of Content; -- Row, Column
   type Rock_Content_Access is not null access Rock_Content;
   
   type Rock is
      record
         Pos : Position; -- Bottom-left corner
         Content : Rock_Content_Access;
      end record;
   
   function Get_Next_Rock return Rock;
   
   function Get_Num_Rocks_Spawned return Natural;
   
   function Content_At ( Row, Column : Positive ) return Content;
   
   function Highest_Level return Natural;
   procedure Print_Field ( Top_Rows : Positive := 32 );
   
   procedure Add_Rock_To_Field ( R : Rock );
   
   procedure Place_Rock;
   
   procedure Try_Move_Left ( R : in out Rock );
   procedure Try_Move_Right ( R : in out Rock );
   
   function Can_Move_Down ( R : Rock ) return Boolean;
   
private
   
   type Field_Row is array ( Positive range 1 .. 7 ) of Content;
   
   procedure Set_Content_At ( Row, Column : Positive );
   -- Will change '.' to '#', anything else is error

end Field;
