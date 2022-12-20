package body Filtering is

   function Filter ( A : Element_Array ) return Element_Array is
      function Recurse ( Accum : Element_Array; Idx : Positive ) return Element_Array is
         Elem : Element_Type := A(Idx);
      begin
         if Predicate( Elem ) then
            return (if Idx = A'Last then Accum & Elem else Recurse( Accum & Elem, Idx+1 ));
         else
            return (if Idx = A'Last then Accum else Recurse( Accum, Idx+1 ));
         end if;
      end Recurse;
      Empty : Element_Array( 1 .. 0 );
   begin
      if A'Length = 1 then
         return Empty;
      else
         return Recurse( Empty, A'First );
      end if;
   end Filter;

end Filtering;
