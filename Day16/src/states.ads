with Valves; use Valves;
with Visiting; use Visiting;

package States is
   
   type Agent is
      record
         Target : Valve_Index;
         Target_Time : Natural;
         Target_Flow : Natural;
      end record;
   

   type State is
      record
         Time : Natural;
         Targets : Node_Log;
         Pressure_Vented, Pressure_Venting : Natural;
         Person, Elephant : Agent;
      end record;
   
   function Get_Best_Release return Natural;
   
private
   
   function Branch ( St : State ) return Natural;

end States;
