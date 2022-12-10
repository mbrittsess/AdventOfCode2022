package Filesystem is

   procedure Move_To_Root;
   procedure Move_To_Child ( Name : String );
   procedure Move_To_Parent;
   
   procedure Add_Directory ( Name : String );
   procedure Add_File ( Name : String; Size : Natural );
   
   procedure Iterate_All_Directory_Sizes ( Process : not null access procedure ( Size : Natural ) );
   
   function Total_Used_Space return Natural;
   
   Bad_Operation : exception;

end Filesystem;
