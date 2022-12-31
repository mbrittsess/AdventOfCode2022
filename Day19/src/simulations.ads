with Resources; use Resources;
with Blueprints; use Blueprints;

package Simulations is

   type State is
      record
         Time : Natural;
         Resources : Resource_Amount;
         Robots : Robot_Amount;
      end record;
   
   function Get_Max_Geodes ( Blp : Blueprint; Max_Time : Natural ) return Natural;

end Simulations;
