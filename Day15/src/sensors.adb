with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Text_IO; use Ada.Text_IO;

package body Sensors is

   function Process_Line ( Line : String ) return Sensor is
      Sens_X_Start : Positive := Index( Line, "x=" )+2;
      Sens_X_End : Positive := Index( Line, ",", Sens_X_Start )-1;
      Sens_Y_Start : Positive := Sens_X_End+5;
      Sens_Y_End : Positive := Index( Line, ":", Sens_Y_Start )-1;
      
      Beac_X_Start : Positive := Index( Line, "x=", Sens_Y_End )+2;
      Beac_X_End : Positive := Index( Line, ",", Beac_X_Start )-1;
      Beac_Y_Start: Positive := Beac_X_End+5;
      Beac_Y_End : Positive := Line'Last;
      
      Sens_X : String := Line( Sens_X_Start .. Sens_X_End );
      Sens_Y : String := Line( Sens_Y_Start .. Sens_Y_End );
      
      Beac_X : String := Line( Beac_X_Start .. Beac_X_End );
      Beac_Y : String := Line( Beac_Y_Start .. Beac_Y_End );
      
      Sens : Position := ( Integer'Value(Sens_X), Integer'Value(Sens_Y) );
      Beac : Position := ( Integer'Value(Beac_X), Integer'Value(Beac_Y) );
   begin
      return ( Sensor => Sens, Beacon => Beac );
   end Process_Line;
   
   function Get_Sensors return Sensor_Sequence is
      function Recurse ( Accum : Sensor_Sequence ) return Sensor_Sequence is
      begin
         if End_Of_File then
            return Accum;
         else
            return Recurse ( Accum & Process_Line( Get_Line ) );
         end if;
      end Recurse;
      Empty : Sensor_Sequence( 1 .. 0 );
   begin
      return Recurse( Empty );
   end Get_Sensors;
   
   All_Sensors_Backing : Sensor_Sequence := Get_Sensors;
   
   function All_Sensors return Sensor_Sequence is (All_Sensors_Backing);
   
begin
   
   --Put_Line( "There are " & All_Sensors_Backing'Length'Image & " sensors read" );
   
   declare
      Min_X, Min_Y : Integer := Integer'Last;
      Max_X, Max_Y : Integer := Integer'First;
   begin
      for Info of All_Sensors loop
         declare
            Sens : Position := Info.Sensor;
            Beac : Position := Info.Beacon;
            Diff : Position := Beac-Sens;
            DeltX : Integer := abs Diff.X;
            DeltY : Integer := abs Diff.Y;
            Dist : Integer := DeltX+DeltY;
         begin
            --Put_Line( To_String(Sens) & ": " & To_String(Beac) & " --> " & To_String(Diff) );
            Min_X := Integer'Min( Min_X, Sens.X-Dist );
            Min_Y := Integer'Min( Min_Y, Sens.Y-Dist );
            Max_X := Integer'Max( Max_X, Sens.X+Dist );
            Max_Y := Integer'Max( Max_Y, Sens.Y+Dist );
            --Put_Line( "  " & Min_X'Image & " " & Min_Y'Image & " " & Max_X'Image & " " & Max_Y'Image );
         end;
      end loop;
      Min_Pos := ( Min_X, Min_Y );
      Max_Pos := ( Max_X, Max_Y );
   end;
   
   --Put_Line( "Tunnels run from " & To_String(Min_Pos) & " to " & To_String(Max_Pos) );
   
end Sensors;
