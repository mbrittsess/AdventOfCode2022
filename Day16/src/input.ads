with Ada.Text_IO; use Ada.Text_IO;

package Input is
   
   pragma Elaborate_Body;
   
   type String_Collection is array ( Positive range <> ) of not null access String;
   
   Lines : constant String_Collection;
   
private
   
   function Get_All_Lines return String_Collection;
   
   Lines : constant String_Collection := Get_All_Lines;

end Input;
