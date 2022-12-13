package body Items is

   function New_Item ( Initial_Value : Integer ) return Item is ( Initial_Value => Initial_Value, others => <> );
   
   procedure Append_Op ( This : in out Item; Op : Operations.Operation ) is
   begin
      This.Own_Operations.Append( Op );
   end Append_Op;
   
   function Evaluate ( This : Item; Divisor : Integer ) return Integer is
      Value :Integer := This.Initial_Value mod Divisor;
   begin
      for Op of This.Own_Operations loop
         Value := Operations.Do_Operation( Op, Value ) mod Divisor;
      end loop;
      return Value;
   end Evaluate;
   
end Items;
