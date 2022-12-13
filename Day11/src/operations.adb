package body Operations is

   function New_Add ( Arg : Integer ) return Operation is ( Kind => Add, Arg => Arg );
   function New_Mul ( Arg : Integer ) return Operation is ( Kind => Mul, Arg => Arg );
   function New_Square return Operation is ( Kind => Square, Arg => Integer'Last );
   
   function Do_Operation ( Op : Operation; Arg : Integer ) return Integer is
   begin
      case Op.Kind is
         when Add => return Op.Arg + Arg;
         when Mul => return Op.Arg * Arg;
         when Square => return Arg**2;
      end case;
   end Do_Operation;

end Operations;
