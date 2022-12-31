with Resources; use Resources;
with Blueprints; use Blueprints;

package Simulations is
   
   function Get_Max_Geodes ( Blp : Blueprint; Max_Time : Natural ) return Natural;
   
private

   type State is
      record
         Time : Natural;
         Resources : Resource_Amount;
         Robots : Robot_Amount;
      end record;

end Simulations;
