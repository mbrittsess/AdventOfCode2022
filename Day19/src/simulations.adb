with Ada.Text_IO; use Ada.Text_IO;

package body Simulations is
   
   type Robot_Sequence is array ( Positive range <> ) of Robot_Kind;
   function "&" ( L : Robot_Sequence; R : Robot_Kind ) return Robot_Sequence is
   begin
      return Ret : Robot_Sequence( 1 .. L'Length+1 ) do
         Ret( 1 .. L'Length ) := L;
         Ret( Ret'Last ) := R;
      end return;
   end "&";

   function Get_Max_Geodes ( Blp : Blueprint; Time : Natural ) return Natural is
      
      Robot_Limits : array ( Robot_Kind ) of Natural := ( Geode => Natural'Last, others => 0 );
      
      function Iterate_State ( S : State ) return Natural is
         
         function Iterate_State_With_Build ( Robot : Robot_Kind ) return Natural is
            New_S : State := S;
         begin
            New_S.Resources := (New_S.Resources - Blp( Robot )) + Production( New_S.Robots );
            New_S.Robots( Robot ) := New_S.Robots( Robot ) + 1;
            New_S.Time := New_S.Time + 1;
            return Iterate_State( New_S );
         end Iterate_State_With_Build;
         
         function Can_Build_Robot ( Robot : Robot_Kind ) return Boolean is (for all Res in Resource_Kind => Blp(Robot)(Res) <= S.Resources(Res));
         function Should_Build_Robot( Robot : Robot_Kind ) return Boolean is (S.Robots(Robot) < Robot_Limits(Robot));
         
      begin
         if S.Time = Time then --We will start at time 0. So after 24 minutes have elapsed, the next minute will start with Time = 24
            --Put_Line( "Reached time 24, returning with " & Natural'Image( S.Resources(Geode) ) & " geodes" );
            return S.Resources(Geode);
         else
            declare
               Max_Geodes : Natural := 0;
            begin
               --Put_Line( "Entering at time " & S.Time'Image & ", trying options" );
               for Robot in Robot_Kind loop
                  if Should_Build_Robot( Robot ) and then Can_Build_Robot( Robot ) then
                     --Put_Line( " Attempting to build " & Robot'Image & " robot" );
                     Max_Geodes := Natural'Max( Max_Geodes, Iterate_State_With_Build( Robot ) );
                  end if;
               end loop;
               -- Simulate choice of doing nothing
               if not (for all Robot in Robot_Kind => Should_Build_Robot(Robot) and then Can_Build_Robot(Robot)) then
                  -- This test is about not needlessly waiting to stockpile resources if we can already build all possible robots
                  declare
                     New_S : State := S;
                  begin
                     --Put_Line( "Attempting to build nothing" );
                     New_S.Resources := New_S.Resources + Production( New_S.Robots );
                     New_S.Time := New_S.Time + 1;
                     Max_Geodes := Natural'Max( Max_Geodes, Iterate_State( New_S ) );
                  end;
               end if;
               
               return Max_Geodes;
            end;
         end if;
      end Iterate_State;
      
      Start_State : State :=
        (
         Time => 0,
         Resources => ( others => 0 ),
         Robots => ( Ore => 1, others => 0 )
        );
   begin
      -- Compute robot limits
      for Resource in Resource_Kind'(Ore) .. Obsidian loop
         for Robot in Robot_Kind loop
            Robot_Limits( Robot_Kind(Resource) ) := Natural'Max( Robot_Limits( Robot_Kind(Resource) ), Blp(Robot)(Resource) );
         end loop;
      end loop;
            
      return Iterate_State( Start_State );
   end Get_Max_Geodes;

end Simulations;
