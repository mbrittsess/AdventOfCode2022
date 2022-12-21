package body States is

   function Branch ( St : State ) return Natural is
      This : State := St;
      function Person_Done return Boolean is (This.Time = This.Person.Target_Time);
      function Elephant_Done return Boolean is (This.Time = This.Elephant.Target_Time);
   begin
      while This.Time /= 26 loop
         if Person_Done then
            This.Pressure_Venting := This.Pressure_Venting + This.Person.Target_Flow;
            if Count_Unvisited( This.Targets ) = 0 then
               This.Person.Target_Time := Natural'Last;
            end if;
         end if;
         if Elephant_Done then
            This.Pressure_Venting := This.Pressure_Venting + This.Elephant.Target_Flow;
            if Count_Unvisited( This.Targets ) = 0 then
               This.Elephant.Target_Time := Natural'Last;
            end if;
         end if;
         
         if Person_Done and Elephant_Done then
            if Count_Unvisited( This.Targets ) = 1 then
               declare
                  Person : Agent := This.Person;
                  Elephant : Agent := This.Elephant;
                  Target_Idx : Valve_Index := Get_Unvisited( This.Targets )(1);
               begin
                  if Time_To_Travel( Person.Target, Target_Idx ) <= Time_To_Travel( Elephant.Target, Target_Idx ) then
                     Person.Target := Target_Idx;
                     Person.Target_Time := This.Time + Time_To_Travel( Person.Target, Target_Idx ) + 1;
                     Person.Target_Flow := Get_Valve( Target_Idx ).Flow_Rate;
                     Elephant.Target_Time := Natural'Last;
                  else
                     Elephant.Target := Target_Idx;
                     Elephant.Target_Time := This.Time + Time_To_Travel( Person.Target, Target_Idx ) + 1;
                     Elephant.Target_Flow := Get_Valve( Target_Idx ).Flow_Rate;
                     Person.Target_Time := Natural'Last;
                  end if;
                  declare
                     New_State : State :=
                       (
                        Time => This.Time,
                        Targets => With_Visited( This.Targets, Target_Idx ),
                        Pressure_Vented => This.Pressure_Vented,
                        Pressure_Venting => This.Pressure_Venting,
                        Person => Person,
                        Elephant => Elephant
                       );
                     Result : Natural := Branch( New_State );
                  begin
                     return Result;
                  end;
               end;
            else
               declare
                  Max_Return : Natural := 0;
               begin
                  for Person_Target_Idx of Get_Unvisited( This.Targets ) loop
                     declare
                        Mid_Targets : Node_Log := With_Visited( This.Targets, Person_Target_Idx );
                     begin
                        for Elephant_Target_Idx of Get_Unvisited( Mid_Targets ) loop
                           declare
                              New_State : State :=
                                (
                                 Time => This.Time,
                                 Targets => With_Visited( Mid_Targets, Elephant_Target_Idx ),
                                 Pressure_Vented => This.Pressure_Vented,
                                 Pressure_Venting => This.Pressure_Venting,
                                 Person =>
                                   (
                                    Target => Person_Target_Idx,
                                    Target_Time => This.Time + Time_To_Travel( This.Person.Target, Person_Target_Idx ) + 1,
                                    Target_Flow => Get_Valve( Person_Target_Idx ).Flow_Rate
                                   ),
                                 Elephant =>
                                   (
                                    Target => Elephant_Target_Idx,
                                    Target_Time => This.Time + Time_To_Travel( This.Elephant.Target, Elephant_Target_Idx ) + 1,
                                    Target_Flow => Get_Valve( Elephant_Target_Idx ).Flow_Rate
                                   )
                                );
                              Candidate_Return : Natural := Branch( New_State );
                           begin
                              Max_Return := Natural'Max( Max_Return, Candidate_Return );
                           end;
                        end loop;
                     end;
                  end loop;
                  return Max_Return;
               end;
            end if;
         elsif Person_Done then
            declare
               Max_Released : Natural := 0;
            begin
               for Target_Idx of Get_Unvisited( This.Targets ) loop
                  declare
                     New_State : State :=
                       (
                        Time => This.Time,
                        Targets => With_Visited( This.Targets, Target_Idx ),
                        Pressure_Vented => This.Pressure_Vented,
                        Pressure_Venting => This.Pressure_Venting,
                        Person =>
                          (
                           Target => Target_Idx,
                           Target_Time => This.Time + Time_To_Travel( From => This.Person.Target, To => Target_Idx ) + 1,
                           Target_Flow => Get_Valve( Target_Idx ).Flow_Rate
                          ),
                        Elephant => This.Elephant
                       );
                     Candidate_Return : Natural := Branch( New_State );
                  begin
                     Max_Released := Natural'Max( Max_Released, Candidate_Return );
                  end;
               end loop;
               return Max_Released;
            end;
         elsif Elephant_Done then
            declare
               Max_Released : Natural := 0;
            begin
               for Target_Idx of Get_Unvisited( This.Targets ) loop
                  declare
                     New_State : State :=
                       (
                        Time => This.Time,
                        Targets => With_Visited( This.Targets, Target_Idx ),
                        Pressure_Vented => This.Pressure_Vented,
                        Pressure_Venting => This.Pressure_Venting,
                        Person => This.Person,
                        Elephant =>
                          (
                           Target => Target_Idx,
                           Target_Time => This.Time + Time_To_Travel( From => This.Elephant.Target, To => Target_Idx ) + 1,
                           Target_Flow => Get_Valve( Target_Idx ).Flow_Rate
                          )
                       );
                     Candidate_Return : Natural := Branch( New_State );
                  begin
                     Max_Released := Natural'Max( Max_Released, Candidate_Return );
                  end;
               end loop;
               return Max_Released;
            end;
         end if;
         
         This.Pressure_Vented := This.Pressure_Vented + This.Pressure_Venting;
         This.Time := This.Time + 1;
      end loop;
      return This.Pressure_Vented;
   end Branch;
   
   function Get_Best_Release return Natural is
      Start_Name : Valve_Name := ( 'A', 'A' );
      Start_Idx : Valve_Index := Get_Valve( Start_Name ).Index;
      Start_State : State :=
        (
         Time => 0,
         Targets => Blank_Log,
         Pressure_Vented => 0,
         Pressure_Venting => 0,
         Person =>
           (
            Target => Start_Idx,
            Target_Time => 0,
            Target_Flow => 0
           ),
         Elephant =>
           (
            Target => Start_Idx,
            Target_Time => 0,
            Target_Flow => 0
           )
        );
   begin
      return Branch( Start_State );
   end Get_Best_Release;
   

end States;
