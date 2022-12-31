package Part2Runners is
   
   pragma Elaborate_Body;

   protected Coordinator is
      procedure Get_Blueprint ( Available : out Boolean; Index : out Positive );
      procedure Update_Results ( Index : in Positive; Geodes : in Natural );
      function Final_Result return Long_Long_Integer;
   private
      Geodes_Mul : Long_Long_Integer := 1;
      Next_Index : Positive := 1;
   end Coordinator;
   
   task type Runner;

end Part2Runners;
