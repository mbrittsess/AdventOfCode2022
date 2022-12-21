with Input;

package Valves is
   
   pragma Elaborate_Body;

   Index_Error : exception;
   
   type Valve;
   
   type Valve_Ptr is not null access Valve;
   
   type Valve_Index is new Integer range 1 .. Input.Lines'Length;
   
   subtype Name_Character is Character range 'A' .. 'Z';
   type Valve_Name is array ( Positive range 1 .. 2 ) of Name_Character;
   
   type Index_Collection is array ( Positive range <> ) of Valve_Index;
   
   type Valve ( Num_Connections : Positive ) is tagged limited
      record
         Flow_Rate : Natural;
         Index : Valve_Index;
         Name : Valve_Name;
         Connections : Index_Collection ( 1 .. Num_Connections );
      end record;
   
   function Get_Valve ( Idx : Valve_Index ) return Valve_Ptr;
   function Get_Valve ( Name : Valve_Name ) return Valve_Ptr;
   
   function Time_To_Travel ( From, To : Valve_Index ) return Natural;

end Valves;
