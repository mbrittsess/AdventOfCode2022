with Ada.Containers, Ada.Containers.Indefinite_Multiway_Trees;
with Ada.Strings.Bounded;
use Ada.Containers;

package body Filesystem is
   package Strings14 is new Ada.Strings.Bounded.Generic_Bounded_Length(13);
   use Strings14;

   type Node_Kind is ( File, Directory );
   type Filesystem_Node ( Kind : Node_Kind ) is
      record
         Name : Strings14.Bounded_String;
         case Kind is
            when File => Size : Natural;
            when others => null;
         end case;
      end record;

   package Filesystem_Trees is new Ada.Containers.Indefinite_Multiway_Trees( Filesystem_Node );
   use Filesystem_Trees;

   Filesystem : Tree := Empty_Tree;
   Cur_Dir : Cursor;

   function At_Root return Boolean is (Depth( Cur_Dir ) = 2);

   function Size ( C : Cursor ) return Natural is
   begin
      if Element(C).Kind = File then
         return Element(C).Size;
      else
         declare
            Total : Natural := 0;
         begin
            for C_Child in Filesystem.Iterate_Children(C) loop
               Total := Total + Size( C_Child );
            end loop;
            return Total;
         end;
      end if;
   end Size;

   function Child_Exists ( Name : String ) return Boolean is
   begin
      for C in Filesystem.Iterate_Children( Cur_Dir ) loop
         if Element(C).Name = Name then
            return true;
         end if;
      end loop;
      return false;
   end Child_Exists;

   procedure Move_To_Root is
   begin
      Cur_Dir := First_Child( Filesystem.Root );
   end Move_To_Root;

   procedure Move_To_Parent is
   begin
      if At_Root then
         raise Bad_Operation with "Can't move to parent when at root";
      else
         Cur_Dir := Parent( Cur_Dir );
      end if;
   end Move_To_Parent;

   procedure Move_To_Child ( Name : String ) is
   begin
      for C in Filesystem.Iterate_Children( Cur_Dir ) loop
         if Element(C).Name = Name then
            case Element(C).Kind is
               when Directory =>
                  Cur_Dir := C;
                  return;
               when File =>
                  raise Bad_Operation with "Can't change current directory to a file";
            end case;
         end if;
      end loop;
      raise Bad_Operation with "No such directory """ & Name & """ to move to";
   end Move_To_Child;

   procedure Add_Directory ( Name : String ) is
   begin
      if Child_Exists( Name ) then
         raise Bad_Operation with "File or directory already exists in this directory called """ & Name & """";
      end if;
      Filesystem.Append_Child( Cur_Dir, ( Kind => Directory, Name => To_Bounded_String(Name) ) );
   end Add_Directory;

   procedure Add_File ( Name : String; Size : Natural ) is
   begin
      if Child_Exists( Name ) then
         raise Bad_Operation with "File or directory already exists in this directory called """ & Name & """";
      end if;
      Filesystem.Append_Child( Cur_Dir, ( Kind => File, Name => To_Bounded_String(Name), Size => Size ) );
   end Add_File;

   procedure Iterate_All_Directory_Sizes ( Process : not null access procedure ( Size : Natural ) ) is
   begin
      for C in Filesystem.Iterate loop
         if Element(C).Kind = Directory then
            Process( Size(C) );
         end if;
      end loop;
   end Iterate_All_Directory_Sizes;

   function Total_Used_Space return Natural is ( Size( First_Child( Filesystem.Root ) ) );

begin
   Filesystem.Append_Child( Filesystem.Root, ( Kind => Directory, Name => To_Bounded_String("") ) );
   Move_To_Root;
end Filesystem;
