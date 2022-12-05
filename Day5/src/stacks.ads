package Stacks is

   Number_of_Stacks : constant := 9;
   Tallest_Start : constant := 8;
   Max_Height : constant := Number_of_Stacks * Tallest_Start;
   
   type Stack_Height is range 0 .. Max_Height;
   subtype Stack_Idx is Stack_Height range 1 .. Stack_Height'Last;
   
   type Crate_ID is new Character range 'A' .. 'Z';
   type Crates is array ( Stack_Idx range <> ) of Crate_ID;
   
   type Stack is private;
   
   function Height ( S : in Stack ) return Stack_Height;
   
   procedure Slip_Under ( S : in out Stack; C : Crate_ID )
     with Pre => Height(S) /= Max_Height;
   
   procedure Put_On_Top ( S : in out Stack; C : Crate_ID )
     with Pre => Height(S) /= Max_Height;
   
   procedure Put_On_Top ( S : in out Stack; C : Crates )
     with Pre => Height(S) <= (Max_Height - C'Length);
   
   function Peek_At_Top ( S : in Stack ) return Crate_ID
     with Pre => Height(S) /= 0;
   
   function Strip_From_Top (S : in out Stack; N : Stack_Height ) return Crates
     with Pre => N <= Height(S);
   
   procedure Move_From_To ( S_From : in out Stack; N : Stack_Height ; S_To : in out Stack )
     with Pre => N <= Height(S_From) and (N + Height(S_To)) <= Max_Height;
   
private
   
   type Stack is
      record
         Height : Stack_Height := 0;
         Contents : Crates( Stack_Idx'Range );
      end record;

end Stacks;
