generic
   type Element_Type is private;
   type Element_Array is array ( Positive range <> ) of Element_Type;
   
   with function "=" ( L, R : Element_Type ) return Boolean is <>;
   with function "<" ( L, R : Element_Type ) return Boolean is <>;
package Functional_1 is
   function Is_Sorted ( A : Element_Array ) return Boolean;
   function Sort ( A : Element_Array ) return Element_Array;
   function Unique ( A : Element_Array ) return Element_Array
     with Pre => Is_Sorted( A );
end Functional_1;
