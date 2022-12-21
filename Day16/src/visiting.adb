package body Visiting is
   
   function Blank_Log return Node_Log is
      Ret : Node_Log;
   begin
      for Idx in Valve_Index loop
         Ret(Idx) := Get_Valve(Idx).Flow_Rate = 0;
      end loop;
      return Ret;
   end Blank_Log;
   
   function With_Visited ( Log : Node_Log; Idx : Valve_Index ) return Node_Log is
      Ret : Node_Log := Log;
   begin
      Ret(Idx) := True;
      return Ret;
   end With_Visited;
   
   function Max_Pressure_Released ( Start_Idx : Valve_Index ) return Natural is
      function Visit
        (
         Log : Node_Log;
         Own_Index : Valve_Index;
         Remaining_Time : Natural;
         Pressure_Released : Natural
        ) return Natural is
         Max_Pressure_Released : Natural := Pressure_Released;
      begin
         if All_Visited( Log ) then
            return Max_Pressure_Released;
         else
            for Idx in Valve_Index loop
               -- Need to have time to travel, time to open valve, and still have at least one more unit left to vent pressure
               if not Log(Idx) and then Time_To_Travel( From => Own_Index, To => Idx )+2 <= Remaining_Time then
                  declare
                     Time_To_Activate : Natural := Time_To_Travel( From => Own_Index, To => Idx )+1;
                     Time_Venting : Natural := Remaining_Time - Time_To_Activate;
                     Additional_Pressure_Vented : Natural := Get_Valve(Idx).Flow_Rate * Time_Venting;
                     New_Log : Node_Log := With_Visited( Log, Idx );
                     Pressure_From_Choice : Natural := Visit( New_Log, Idx, Remaining_Time-Time_To_Activate, Pressure_Released+Additional_Pressure_Vented );
                  begin
                     Max_Pressure_Released := Natural'Max( Max_Pressure_Released, Pressure_From_Choice );
                  end;
               end if;
            end loop;
            return Max_Pressure_Released;
         end if;
      end Visit;
   begin
      return Visit( With_Visited( Blank_Log, Start_Idx ), Start_Idx, 30, 0 );
   end Max_Pressure_Released;
   

end Visiting;
