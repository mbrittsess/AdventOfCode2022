with Ada.Unchecked_Deallocation;
with Ada.Text_IO; use Ada.Text_IO;

package body Data_Elements is
   
   Cant_Happen : exception;
   
   procedure Free_Element is new Ada.Unchecked_Deallocation( Object => Data_Element, Name => Data_Element_Access );
   
   procedure Append_Element ( List_Element : not null List_Element_Access; New_Element : not null Data_Element_Access ) is
   begin
      List_Element.Values.Append( New_Element );
   end Append_Element;
   
   function Length ( List_Element : not null List_Element_Access ) return Natural is
   begin
      return Natural( List_Element.Values.Length );
   end Length;

   function New_Number ( N : Integer ) return not null Number_Element_Access is
   begin
      return new Data_Element'( Kind => Number, Value => N );
   end New_Number;
   
   function New_Number ( S : String ) return not null Number_Element_Access is
   begin
      return new Data_Element'( Kind => Number, Value => Integer'Value(S) );
   exception
      when CE : Constraint_Error => raise Parse_Error with "Unrecognized number format '" & S & "'";
      when E : others => raise;
   end New_Number;
   
   -- Idx enters with the starting index of the number, exits one past the final character of the number
   function New_Number ( S : String; Idx : in out Positive ) return not null Number_Element_Access is
      Start_Idx, Cur_Idx : Positive := Idx;
   begin
      if not (S(Start_Idx) in '0'..'9') then
         raise Parse_Error with "Unexpected character '" & S(Start_Idx) & "'";
      end if;
      while Cur_Idx < S'Last and S(Cur_Idx+1) in '0'..'9' loop
         Cur_Idx := Cur_Idx+1;
      end loop;
      Idx := Cur_Idx+1;
      return New_Number( S( Start_Idx .. Cur_Idx ) );
   end New_Number;
   
   function New_List return not null List_Element_Access is
   begin
      return new Data_Element'( Kind => List, others => <> );
   end New_List;
   
   function New_List ( S : String; Idx : in out Positive ) return not null List_Element_Access is
      Ret : List_Element_Access := New_List;
      Cur_Idx : Positive := Idx+1;
   begin
      if S(Idx) /= '[' then
         raise Parse_Error with "Expected '[', got '" & S(Idx) & "'";
      end if;
      while S(Cur_Idx) /= ']' loop
         case S(Cur_Idx) is
            when '[' => Append_Element( Ret, New_List( S, Cur_Idx ) );
            when '0' .. '9' => Append_Element( Ret, New_Number( S, Cur_Idx ) );
            when others => raise Parse_Error with "Unexpected character '" & S(Cur_Idx) & "'";
         end case;
         if S(Cur_Idx) = ',' then
            Cur_Idx := Cur_Idx+1;
         end if;
      end loop;
      Idx := Cur_Idx + 1;
      return Ret;
   end New_List;
   
   function New_Data ( S : String ) return Data_Element_Access is
      Idx : Positive := S'First;
   begin
      if S(Idx) = '[' then
         return New_List( S, Idx );
      else
         return New_Number( S, Idx );
      end if;
   end New_Data;
   
   function To_List ( Number_Element : not null Number_Element_Access ) return not null List_Element_Access is
      Ret : List_Element_Access := New_List;
   begin
      Append_Element( Ret, Number_Element );
      return Ret;
   end To_List;
   
   type Compare_Result is ( '<', '=', '>' );
   
   --Is a less-than comparison, can be a less-than-or-equal if second parameter is true
   function Compare ( Left, Right : not null Data_Element_Access ) return Compare_Result is
   begin
      if Left.Kind = Number and Right.Kind = Number then
         declare
            A : Integer := Left.Value;
            B : Integer := Right.Value;
         begin
            if A = B then
               return '=';
            elsif A < B then
               return '<';
            else
               return '>';
            end if;
         end;
      elsif Left.Kind = List and Right.Kind = List then
         declare
            A : Data_Vectors.Vector renames Left.Values;
            B : Data_Vectors.Vector renames Right.Values;
         begin
            for Idx in A.First_Index .. Positive'Max( A.Last_Index, B.Last_Index )+1 loop
               declare
                  A_In_Range : Boolean := Idx <= A.Last_Index;
                  B_In_Range : Boolean := Idx <= B.Last_Index;
               begin
                  if A_In_Range and B_In_Range then --Compare elements
                     declare
                        Result : Compare_Result := Compare(A(Idx), B(Idx));
                     begin
                        if Result /= '=' then
                           return Result;
                        end if;
                        --Elements were equal, so continue loop
                     end;
                  elsif (not A_In_Range) and (not B_In_Range) then --Both lists were equal in values and length
                     return '=';
                  elsif not A_In_Range then --A is shorter
                     return '<';
                  else
                     return '>';
                  end if;
               end;
            end loop;
            raise Cant_Happen;
         end;
      elsif Left.Kind = List then --Right is an integer, must convert to list
         declare
            Right_List : Data_Element_Access := New_List;
            Result : Compare_Result;
         begin
            Append_Element( Right_List, Right );
            Result := Compare( Left, Right_List );
            Free_Element( Right_List );
            return Result;
         end;
      else --Left is an integer, must convert to list
         declare
            Left_List : Data_Element_Access := New_List;
            Result : Compare_Result;
         begin
            Append_Element( Left_List, Left );
            Result := Compare( Left_List, Right );
            Free_Element( Left_List );
            return Result;
         end;
      end if;
   end Compare;
   
   function "<" ( Left, Right : Data_Element_Access ) return Boolean is (Compare(Left,Right) = '<');
   function "<=" ( Left, Right : Data_Element_Access ) return Boolean is (Compare(Left,Right) /= '>');
   
   function To_String ( D : Data_Element_Access ) return String is
   begin
      case D.Kind is
         when Number => return D.Value'Image;
         when List => return List_To_String(D);
      end case;
   end To_String;
   
   function List_To_String ( L : not null List_Element_Access ) return String is
   begin
      return "[" & List_To_String(L, L.Values.First_Index);
   end List_To_String;
   
   function List_To_String ( L : not null List_Element_Access; Idx : Positive ) return String is
      Prefix : String := (if Idx = L.Values.First_Index then "" else ",");
      Is_In_Range : Boolean := (not L.Values.Is_Empty) and Idx <= L.Values.Last_Index;
      Own : String := (if Is_In_Range then To_String(L.Values(Idx)) else "");
      Next_Is_In_Range : Boolean := (not L.Values.Is_Empty) and (Idx+1) <= L.Values.Last_Index;
      Postfix : String := (if Next_Is_In_Range then List_To_String(L, Idx+1) else "]");
   begin
      return Prefix & Own & Postfix;
   end List_To_String;

end Data_Elements;
