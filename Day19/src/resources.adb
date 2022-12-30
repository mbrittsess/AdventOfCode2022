package body Resources is
   
   function "+" ( L, R : Resource_Amount ) return Resource_Amount is
   begin
      return Ret : Resource_Amount do
         for Resource in Resource_Kind loop
            Ret( Resource ) := L( Resource ) + R( Resource );
         end loop;
      end return;
   end "+";
   
   function "-" ( L, R : Resource_Amount ) return Resource_Amount is
   begin
      return Ret : Resource_Amount do
         for Resource in Resource_Kind loop
            Ret( Resource ) := L( Resource ) - R( Resource );
         end loop;
      end return;
   end "-";

   function Production ( R : Robot_Amount ) return Resource_Amount is
   begin
      return Ret : Resource_Amount do
         for Robot in Robot_Kind loop
            Ret( Resource_Kind(Robot) ) := R(Robot);
         end loop;
      end return;
   end Production;

end Resources;
