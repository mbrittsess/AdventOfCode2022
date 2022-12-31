package Part1Runners is
   
   pragma Elaborate_Body;

   protected Coordinator is
      procedure Get_Blueprint ( Available : out Boolean; Index : out Positive );
      procedure Update_Results ( Index : in Positive; Geodes : in Natural );
      function Final_Result return Natural;
   private
      Total_Quality : Natural := 0;
      Next_Index : Positive := 1;
   end Coordinator;
   
   task type Runner;

end Part1Runners;
