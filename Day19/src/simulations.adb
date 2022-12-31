with Ada.Text_IO; use Ada.Text_IO;

package body Simulations is
   
   function Compute_Robot_Limits ( Blp : Blueprint ) return Robot_Amount is
   begin
      return Amts : Robot_Amount := ( Geode => Natural'Last, others => <> ) do
         for Resource in Resource_Kind'(Ore) .. Obsidian loop
            for Robot in Robot_Kind loop
               Amts( Robot_Kind(Resource) ) := Natural'Max( Amts( Robot_Kind(Resource) ), Blp(Robot)(Resource) );
            end loop;
         end loop;
      end return;
   end Compute_Robot_Limits;
         
   function With_One_More ( Amts : Robot_Amount; Robot : Robot_Kind ) return Robot_Amount is
   begin
      return New_Amts : Robot_Amount := Amts do
         New_Amts( Robot ) := New_Amts( Robot ) + 1;
      end return;
   end With_One_More;
      
   function Get_Max_Geodes ( Blp : Blueprint; Max_Time : Natural ) return Natural is
      Max_Geodes_Yet : Natural := 0;
      procedure Update_Max ( G : Natural ) is
      begin
         Max_Geodes_Yet := Natural'Max( Max_Geodes_Yet, G );
      end Update_Max;
      
      Robot_Limits : Robot_Amount := Compute_Robot_Limits( Blp );
   
      function Max_Potential_Geodes ( S : State ) return Natural is
      begin
         return Ret : Natural := S.Resources(Geode) do
            for N in S.Robots(Geode) .. S.Robots(Geode)+((Max_Time-S.Time)-1) loop
               Ret := Ret + N;
            end loop;
         end return;
      end Max_Potential_Geodes;
      
      procedure Iterate_State ( S : State ) is
         Time : Natural := S.Time;
         
         function Can_Build_Robot ( Robot : Robot_Kind ) return Boolean is (for all Res in Resource_Kind => Blp(Robot)(Res) <= S.Resources(Res));
         function Should_Build_Robot( Robot : Robot_Kind ) return Boolean is (S.Robots(Robot) < Robot_Limits(Robot));
      begin
         --Put_Line( "Entering time " & S.Time'Image & " with " & Natural'Image( S.Resources(Geode) ) & " geodes and " & Natural'Image( S.Robots(Geode) ) & " geode robots." );
         if Time = Max_Time then
            Update_Max( S.Resources(Geode) );
            return;
         elsif Max_Potential_Geodes( S ) <= Max_Geodes_Yet then
            return;
         else
            declare
               Can_Build_All : Boolean := True;
            begin
               -- Try building all available robots, starting with Geode robots to maximize the chance that later branches return early because they can't do better than what's been encountered
               for Robot in reverse Robot_Kind loop
                  declare
                     Can_Build_This : Boolean := Can_Build_Robot( Robot );
                     Should_Build_This : Boolean := Should_Build_Robot( Robot );
                  begin
                     if Should_Build_This then
                        Can_Build_All := Can_Build_All and Can_Build_This;
                        if Can_Build_This then
                           Iterate_state( ( Time => Time+1, Resources => (S.Resources + Production( S.Robots )) - Blp(Robot), Robots => With_One_More( S.Robots, Robot ) ) );
                        end if;
                     end if;
                  end;
               end loop;
               -- If at least one robot should have been built but not enough resources were available, try waiting:
               if not Can_Build_All then
                  Iterate_State( ( Time => Time+1, Resources => S.Resources + Production( S.Robots ), Robots => S.Robots ) );
               end if;
               return;
            end;
         end if;
      end Iterate_State;
   begin
      Iterate_State( ( Time => 0, Resources => ( others => 0 ), Robots => ( Ore => 1, others => 0 ) ) );
      return Max_Geodes_Yet;
   end Get_Max_Geodes;
   
end Simulations;
