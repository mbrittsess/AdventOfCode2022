package body Stacks is
   
   function Height ( S : in Stack ) return Stack_Height is
   begin
      return S.Height;
   end Height;
   
   procedure Slip_Under ( S : in out Stack; C : Crate_ID ) is
   begin
      for I in reverse 1 .. S.Height loop
         S.Contents(I+1) := S.Contents(I);
      end loop;
      S.Contents(1) := C;
      S.Height := S.Height+1;
   end Slip_Under;
   
   procedure Put_On_Top ( S : in out Stack; C : Crate_ID ) is
   begin
      S.Contents( S.Height+1 ) := C;
      S.Height := S.Height + 1;
   end Put_On_Top;
   
   procedure Put_On_Top ( S : in out Stack; C : Crates ) is
   begin
      S.Contents( S.Height+1 .. S.Height+C'Length ) := C;
      S.Height := S.Height + C'Length;
   end Put_On_Top;
   
   function Peek_At_Top ( S : in Stack ) return Crate_ID is
   begin
      return S.Contents( S.Height );
   end Peek_At_Top;
   
   --Reverses their order
   function Strip_From_Top ( S : in out Stack; N : Stack_Height ) return Crates is
      Orig_Crates : Crates := S.Contents( ((S.Height-N)+1) .. S.Height );
      Returned_Crates : Crates( Orig_Crates'Range );
   begin
      for I in Orig_Crates'Range loop
         Returned_Crates( Orig_Crates'Last - (I-Orig_Crates'First) ) := Orig_Crates(I);
      end loop;
      S.Height := S.Height - N;
      return Returned_Crates;
   end Strip_From_Top;
   
   --Doesn't reverse order
   function Grab_From_Top ( S : in out Stack; N : Stack_Height ) return Crates is
   begin
      S.Height := S.Height - N;
      return S.Contents( S.Height+1 .. S.Height+N );
   end Grab_From_Top;
   
   procedure Move_From_To ( S_From : in out Stack; N : Stack_Height; S_To : in out Stack ) is
   begin
      Put_On_Top( S_To, Strip_From_Top( S_From, N ) );
   end Move_From_To;
   
   procedure Move_All_From_To ( S_From : in out Stack; N : Stack_Height; S_To : in out Stack ) is
   begin
      Put_On_Top( S_To, Grab_From_Top( S_From, N ) );
   end Move_All_From_To;

end Stacks;
