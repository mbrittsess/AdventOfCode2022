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
   
   function To_String ( R : Int_Range ) return String is
   begin
      return "[" & R.Lo'Image & " .. " & R.Hi'Image & "]";
   end To_String;
   
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
            --Put_Line( "Line " & Line_Y'Image & " Sensors In Range Count: " & Integer'Image( In_Sensors'Length ) );
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
            --for IR of Ret_Arr loop
               --Put_Line("  " & To_String(IR) );
            --end loop;
            
            return Ret_Arr;
         end Get_Sorted_X_Ranges;
         
         function Get_Collapsed_X_Ranges return Ranges is
            In_Ranges : Ranges := Get_Sorted_X_Ranges;
            function Recurse ( Accum : Ranges; Idx : Positive ) return Ranges is
               Cur : Int_Range := Accum( Accum'Last );
               Next : Int_Range := In_Ranges(Idx);
               Does_Overlap : Boolean := (Cur.Lo <= Next.Hi) and then (Next.Lo <= Cur.Hi);
               Does_Abut : Boolean := (Cur.Hi+1 = Next.Lo) or else (Next.Hi+1 = Cur.Lo);
            begin
               if Does_Overlap or else Does_Abut then
                  declare
                     Merged_Element : Int_Range := ( Lo => Integer'Min( Cur.Lo, Next.Lo ), Hi => Integer'Max( Cur.Hi, Next.Hi ) );
                     New_Accum : Ranges := Accum( Accum'First .. Accum'Last-1 ) & Merged_Element;
                  begin
                     if Idx = In_Ranges'Last then
                        return New_Accum;
                     else
                        return Recurse( New_Accum, Idx+1 );
                     end if;
                  end;
               else
                  declare
                     New_Accum : Ranges := Accum & Next;
                  begin
                     if Idx = In_Ranges'Last then
                        return New_Accum;
                     else
                        return Recurse( New_Accum, Idx+1 );
                     end if;
                  end;
               end if;
            end Recurse;
         begin
            if In_Ranges'Length <= 1 then
               return In_Ranges;
            else
               declare
                  Start_Accum : Ranges := ( 1 => In_Ranges(In_Ranges'First) );
               begin
                  return Recurse( Start_Accum, In_Ranges'First+1 );
               end;
            end if;
         end Get_Collapsed_X_Ranges;
         
         -- Will eliminate any portion of a range which is entirely outside of bounds
         function Get_Stripped_Ranges return Ranges is
            function In_Bounds ( IR : Int_Range ) return Boolean is (0 <= IR.Hi and then IR.Lo <= Max_Y);
            package Range_Filtering is new Filtering( Element_Type => Int_Range, Element_Array => Ranges, Predicate => In_Bounds );
            Collapsed_Ranges : Ranges := Get_Collapsed_X_Ranges;
         begin
            --Put_Line( "Line " & Line_Y'Image & " Filtered Ranges Count: " & Integer'Image( Collapsed_Ranges'Length ) );
            --for IR of Collapsed_Ranges loop
               --Put_Line("  " & To_String(IR) );
            --end loop;
            
            return Range_Filtering.Filter( Collapsed_Ranges );
         end Get_Stripped_Ranges;
         
         -- Will truncate any range which is partially out of bounds to be entirely in bounds
         function Get_Truncated_Ranges return Ranges is
            Ret_Arr : Ranges := Get_Stripped_Ranges;
         begin
            for Idx in Ret_Arr'Range loop
               Ret_Arr(Idx) := ( Lo => Integer'Max( 0, Ret_Arr(Idx).Lo ), Hi => Integer'Min( Max_Y, Ret_Arr(Idx).Hi ) );
            end loop;
            return Ret_Arr;
         end Get_Truncated_Ranges;
         
         Line_Ranges : Ranges := Get_Truncated_Ranges;
      begin
         if Line_Y mod 2**14 = 0 then
            Put_Line( "Reached line " & Line_Y'Image );
         end if;
         --Put_Line( "Line " & Line_Y'Image & " Truncated Ranges Count: " & Integer'Image( Line_Ranges'Length ) );
         --for IR of Line_Ranges loop
            --Put_Line( "  " & To_String(IR) );
         --end loop;
         if Line_Ranges'Length = 2 and then (Line_Ranges(2).Lo - Line_Ranges(1).Hi) = 2 then
            declare
               Tuning_Frequency : Long_Long_Integer := Long_Long_Integer(Line_Y) + Long_Long_Integer(Line_Ranges(1).Hi+1)*Max_Y;
            begin
               Put_Line( "Candidate found at: x=" & Integer'Image(Line_Ranges(1).Hi+1) & ",y=" & Line_Y'Image & ", tuning frequency is " & Tuning_Frequency'Image );
            end;
         end if;
      end;
   end loop;
   
end Day15Part2;
