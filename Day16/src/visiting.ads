with Valves; use Valves;

package Visiting is

   -- True for any valve which either has no flow, or hasn't been activated yet
   type Node_Log is array ( Valve_Index ) of Boolean;
   
   function Blank_Log return Node_Log;
   
   function With_Visited ( Log : Node_Log; Idx : Valve_Index ) return Node_Log;
   
   function All_Visited ( Log : Node_Log ) return Boolean is (for all Visits of Log => Visits);
   
   function Max_Pressure_Released ( Start_Idx : Valve_Index ) return Natural;

end Visiting;
