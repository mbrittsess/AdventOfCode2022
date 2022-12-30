package Resources is

   type Resource_Kind is ( Ore, Clay, Obsidian, Geode );
   type Robot_Kind is new Resource_Kind;
   
   type Resource_Amount is array ( Resource_Kind ) of Natural;
   type Robot_Amount is array ( Robot_Kind ) of Natural;
   
   function "+" ( L, R : Resource_Amount ) return Resource_Amount;
   function "-" ( L, R : Resource_Amount ) return Resource_Amount;
   function Production ( R : Robot_Amount ) return Resource_Amount;

end Resources;
