with Positions; use Positions;

package Sensors is
   
   pragma Elaborate_Body;
   
   type Sensor is
      record
         Sensor, Beacon : Position;
      end record;
   type Sensor_Sequence is array ( Positive range <> ) of Sensor;
   
   function All_Sensors return Sensor_Sequence;
   
   Min_Pos, Max_Pos : Position;

private
   
   -- Parses line of input, fills-in field, updates recorded min/max values
   function Process_Line ( Line : String ) return Sensor;
   function Get_Sensors return Sensor_Sequence;

end Sensors;
