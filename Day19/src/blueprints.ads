with Resources; use Resources;

package Blueprints is

   type Blueprint is array ( Robot_Kind ) of Resource_Amount;
   
   type Blueprint_Sequence is array ( Positive range <> ) of Blueprint;
   
   function Blueprints return Blueprint_Sequence;
   
private
   
   function Read_Blueprint return Blueprint;
   
   function Read_All_Blueprints return Blueprint_Sequence;

end Blueprints;
