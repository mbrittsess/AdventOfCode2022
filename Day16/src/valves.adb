with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Containers.Vectors;

package body Valves is

   type Valve_Name_Lookup is array ( Name_Character, Name_Character ) of Valve_Index;
   
   Valid_Name : array ( Name_Character, Name_Character ) of Boolean := ( others => ( others => False ) );
   
   function Create_Name_Lookup return Valve_Name_Lookup is
      Ret_Arr : Valve_Name_Lookup;
   begin
      for Idx in Input.Lines'Range loop
         declare
            Line : String := Input.Lines(Idx).all;
            A : Name_Character := Line(7);
            B : Name_Character := Line(8);
         begin
            Valid_Name(A,B) := True;
            Ret_Arr(A,B) := Valve_Index(Idx);
         end;
      end loop;
      return Ret_Arr;
   end Create_Name_Lookup;
   
   Name_Lookup : Valve_Name_Lookup := Create_Name_Lookup;
   
   type Valve_Ptr_Collection is array ( Valve_Index range <> ) of Valve_Ptr;
   subtype Valve_Ptr_Lookup is Valve_Ptr_Collection( Valve_Index'Range );
   
   function Create_Valves return Valve_Ptr_Lookup is
      function Create_Valve ( Idx : Valve_Index ) return Valve_Ptr is
         Line : String := Input.Lines( Positive(Idx) ).all;
         Name : Valve_Name := ( Line(7), Line(8) );
         Flow_Rate : Natural := Natural'Value( Line( 24 .. Index( Line, ";", 24 )-1 ) );
         Num_Connections : Positive := Count( Line, "," )+1;
         Connections : Index_Collection( 1 .. Num_Connections );
         Connections_Start : Positive := Index( Line, " ", Index( Line, "valve", 2 ) )+1;
      begin
         for Conn_Idx in 1 .. Num_Connections loop
            declare
               Base : Positive := Connections_Start + (Conn_Idx-1)*4;
            begin
               Connections( Conn_Idx ) := Name_Lookup( Line(Base), Line(Base+1) );
            end;
         end loop;
         return new Valve'( Num_Connections => Num_Connections, Flow_Rate => Flow_Rate, Index => Idx, Name => Name, Connections => Connections );
      end Create_Valve;
         
      function Recurse ( Accum : Valve_Ptr_Collection; Idx : Valve_Index ) return Valve_Ptr_Collection is
         Next_Part : Valve_Ptr_Collection( 1 .. 1 ) := ( 1 => Create_Valve(Idx) );
         New_Accum : Valve_Ptr_Collection := Accum & Next_Part;
      begin
         if Idx = Valve_Index'Last then
            return New_Accum;
         else
            return Recurse( New_Accum, Idx+1 );
         end if;
      end Recurse;
      
      Start : Valve_Ptr_Collection( 1 .. 1 ) := ( 1 => Create_Valve(1) );
   begin
      return Recurse( Start, 2 );
   end Create_Valves;
   
   Root_Valves : Valve_Ptr_Lookup := Create_Valves;
   
   function Get_Valve ( Idx : Valve_Index ) return Valve_Ptr is (Root_Valves(Idx));
   function Get_Valve ( Name : Valve_Name ) return Valve_Ptr is
      A : Name_Character := Name(1);
      B : Name_Character := Name(2);
   begin
      if Valid_Name(A,B) then
         return Get_Valve( Name_Lookup(A,B) );
      else
         raise Index_Error;
      end if;
   end Get_Valve;
   
   Distances : array ( Valve_Index, Valve_Index ) of Natural := ( others => ( others => 0 ) );
   
   function Time_To_Travel ( From, To : Valve_Index ) return Natural is (Distances(From,To));
   
begin
   -- Fill out the array of distances to each node
   declare
      package Index_Vectors is new Ada.Containers.Vectors( Index_Type => Positive, Element_Type => Valve_Index );
      Queue : Index_Vectors.Vector := Index_Vectors.Empty_Vector;
      function Dequeue return Valve_Index is
         Ret : Valve_Index := Queue.First_Element;
      begin
         Queue.Delete_First;
         return Ret;
      end Dequeue;
   begin
      for Start_Idx in Valve_Index loop
         declare
            Visited : array ( Valve_Index ) of Boolean := ( others => False );
         begin
            Queue.Append( Start_Idx );
            Visited( Start_Idx ) := True;
            while not Queue.Is_Empty loop
               declare
                  Cur_Idx : Valve_Index := Dequeue;
                  Cur_Dist : Natural := Distances( Start_Idx, Cur_Idx );
               begin
                  for Adj_Idx of Get_Valve(Cur_Idx).Connections loop
                     if not Visited(Adj_Idx) then
                        Queue.Append( Adj_Idx );
                        Visited( Adj_Idx ) := True;
                        Distances( Start_idx, Adj_Idx ) := Cur_Dist+1;
                     end if;
                  end loop;
               end;
            end loop;
         end;
      end loop;
   end;
   
end Valves;
