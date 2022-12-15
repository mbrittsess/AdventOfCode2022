with Ada.Containers.Vectors;

package Data_Elements is
   
   Parse_Error : exception;

   type Data_Element_Access is private;
   
   function New_Data ( S : String ) return Data_Element_Access;
   
   function "<" ( Left, Right : Data_Element_Access ) return Boolean;
   function "<=" ( Left, Right : Data_Element_Access ) return Boolean;
   
   function To_String ( D : Data_Element_Access ) return String;
   
private
   
   type Data_Element_Kind is ( Number, List );
   type Data_Element( Kind : Data_Element_Kind );
   type Data_Element_Access is access Data_Element;
   subtype Number_Element_Access is Data_Element_Access(Number);
   subtype List_Element_Access is Data_Element_Access(List);
   
   package Data_Vectors is new Ada.Containers.Vectors( Positive, Data_Element_Access );
   
   type Data_Element ( Kind : Data_Element_Kind ) is limited
      record
         case Kind is
            when Number => Value : Integer;
            when List => Values : Data_Vectors.Vector := Data_Vectors.Empty_Vector;
         end case;
      end record;
   
   function List_To_String ( L : not null List_Element_Access ) return String;
   function List_To_String ( L : not null List_Element_Access; Idx : Positive ) return String;

end Data_Elements;
