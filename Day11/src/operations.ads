package Operations is

   type Operation is private;
   function New_Add ( Arg : Integer ) return Operation;
   function New_Mul ( Arg : Integer ) return Operation;
   function New_Square return Operation;
   function Do_Operation ( Op : Operation; Arg : Integer ) return Integer;

private
   
   type Operation_Kind is ( Add, Mul, Square );
   
   type Operation is
      record
         Kind : Operation_Kind;
         Arg : Integer;
      end record;

end Operations;
