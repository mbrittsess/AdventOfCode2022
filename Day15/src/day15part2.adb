with Positions; use Positions;
with Sensors; use Sensors;
with Filtering;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Generic_Array_Sort;

procedure Day15Part2 is
   Max_Y : constant := 4_000_000;
   
   type Int_Range is
      record
         Lo, Hi : Integer;
      end record with Dynamic_Predicate => Int_Range.Lo <= Int_Range.Hi;
   
   type Ranges is array ( Positive range <> ) of Int_Range;
   
   function "<" ( L, R : Int_Range ) return Boolean is (L.Lo < R.Lo);
   
   function Within_Sensor_Range ( Info : Sensor; Y : Integer ) return Boolean is
      Sens_Pos : Position := Info.Sensor;
      Dist : Integer := abs (Info.Beacon - Info.Sensor);
      Sens_Min_Y : Integer := Sens_Pos.Y - Dist;
      Sens_Max_Y : Integer := Sens_Pos.Y + Dist;
   begin
      return Y in Sens_Min_Y .. Sens_Max_Y;
   end Within_Sensor_Range;
   
   function Get_Sensor_Range ( Info : Sensor; Y : Integer ) return Int_Range is
   begin
      if not Within_Sensor_Range( Info, Y ) then
         raise Constraint_Error with "Coordinate Y = " & Y'Image & " not within range of sensor at " & To_String( Info.Sensor );
      end if;
      declare
         Sens_Pos : Position := Info.Sensor;
         Dist : Integer := abs (Info.Beacon - Info.Sensor);
         Wiggle : Integer := Dist - (abs (Y-Sens_Pos.Y));
      begin
         return ( Lo => Sens_Pos.X-Wiggle, Hi => Sens_Pos.X+Wiggle );
      end;
   end Get_Sensor_Range;
   
begin
   for Line_Y in 0 .. Max_Y loop
      declare
         function Get_Sensors_In_Range return Sensor_Sequence is
            In_Sensors : Sensor_Sequence := All_Sensors;
            function Recurse ( Accum : Sensor_Sequence; Idx : Positive ) return Sensor_Sequence is
               Candidate : Sensor := In_Sensors(Idx);
            begin
               declare
                  New_Accum : Sensor_Sequence := (if Within_Sensor_Range( Candidate, Line_Y ) then Accum & Candidate else Accum);
               begin
                  if Idx = In_Sensors'Last then
                     return New_Accum;
                  else
                     return Recurse( New_Accum, Idx+1 );
                  end if;
               end;
            end Recurse;
            Empty : Sensor_Sequence( 1 .. 0 );
         begin
            return Recurse( Empty, In_Sensors'First );
         end Get_Sensors_In_Range;
         
         function Get_X_Ranges return Ranges is
            In_Sensors : Sensor_Sequence := Get_Sensors_In_Range;
            Ret_Arr : Ranges( In_Sensors'Range );
         begin
            for Idx in In_Sensors'Range loop
               Ret_Arr(Idx) := Get_Sensor_Range( In_Sensors(Idx), Line_Y );
            end loop;
            return Ret_Arr;
         end Get_X_Ranges;
         
         function Get_Sorted_X_Ranges return Ranges is
            procedure Sort is new Ada.Containers.Generic_Array_Sort( Index_Type => Positive, Element_Type => Int_Range, Array_Type => Ranges );
            Ret_Arr : Ranges := Get_X_Ranges;
         begin
            Sort( Ret_Arr );
            return Ret_Arr;
         end Get_Sorted_X_Ranges;
         
         function Get_Collapsed_X_Ranges return Ranges is
            In_Ranges : Ranges := Get_Sorted_X_Ranges;
            --TODO
      begin
         null;
      end;
      
   end loop;
   
end Day15Part2;
