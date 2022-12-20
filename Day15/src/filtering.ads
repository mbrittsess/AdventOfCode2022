generic
   type Element_Type is private;
   type Element_Array is array ( Positive range <> ) of Element_Type;
   
   with function Predicate ( E : Element_Type ) return Boolean;
package Filtering is
   function Filter ( A : Element_Array ) return Element_Array;
end Filtering;
