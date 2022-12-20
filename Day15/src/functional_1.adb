with Ada.Containers.Generic_Array_Sort;

package body Functional_1 is
   
   function "<=" ( L, R : Element_Type ) return Boolean is ((L = R) or else (L < R));

   function Is_Sorted ( A : Element_Array ) return Boolean is
   begin
      if A'Length <= 1 then
         return True;
      end if;
      
      for Idx in A'First .. A'Last-1 loop
         if not (A(Idx) <= A(Idx+1)) then
            return False;
         end if;
      end loop;
      return True;
   end Is_Sorted;
   
   function Sort ( A : Element_Array ) return Element_Array is
      procedure Sort is new Ada.Containers.Generic_Array_Sort
        (
         Index_Type => Positive,
         Element_Type => Element_Type,
         Array_Type => Element_Array
        );
      Ret : Element_Array := A;
   begin
      Sort( Ret );
      return Ret;
   end Sort;
   
   function Unique ( A : Element_Array ) return Element_Array is
      function Recurse ( Accum : Element_Array; Idx : Positive ) return Element_Array is
         Elem : Element_Type := A(Idx);
      begin
         if Elem = A(Idx-1) then
            return (if Idx = A'Last then Accum else Recurse( Accum, Idx+1 ));
         else
            return (if Idx = A'Last then Accum else Recurse( Accum & Elem, Idx+1 ));
         end if;
      end Recurse;
   begin
      if A'Length <= 1 then
         return A;
      else
         return Recurse( ( 1 => A(A'First) ), A'First+1 );
      end if;
   end Unique;

end Functional_1;
