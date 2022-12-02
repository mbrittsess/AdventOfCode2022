with Ada.Text_IO; use Ada.Text_IO;

procedure Day2Part2 is
   type Play is ( Rock, Paper, Scissors );
   type Outcome is ( Loss, Draw, Win );
   
   Rules : constant array ( Play, Play ) of Outcome := -- Your play, their play, your outcome
     (
      Rock     => ( Rock     => Draw,
                    Paper    => Loss,
                    Scissors => Win ),

      Paper    => ( Rock     => Win,
                    Paper    => Draw,
                    Scissors => Loss ),

      Scissors => ( Rock     => Loss,
                    Paper    => Win,
                    Scissors => Draw )
     );
   
   Required_Play : constant array ( Play, Outcome ) of Play := --Their play, your desired outcome, your necessary play
     (
      Rock     => ( Loss => Scissors,
                    Draw => Rock,
                    Win  => Paper ),
      
      Paper    => ( Loss => Rock,
                    Draw => Paper,
                    Win  => Scissors ),
      
      Scissors => ( Loss => Paper,
                    Draw => Scissors,
                    Win  => Rock )
     );
   
   type Score is range 0 .. Integer'Last;
   package Score_IO is new Integer_IO( Score );
   
   Play_Score : constant array ( Play ) of Score := ( Rock => 1, Paper => 2, Scissors => 3 );
   Outcome_Score : constant array ( Outcome ) of Score := ( Loss => 0, Draw => 3, Win => 6 );
   
   type Play_Code is ( A, B, C );
   Play_Code_Map : constant array ( Play_Code ) of Play := ( Rock, Paper, Scissors );
   
   type Outcome_Code is ( X, Y, Z );
   Outcome_Code_Map : constant array ( Outcome_Code ) of Outcome := ( X => Loss, Y => Draw, Z => Win );
   
   package Play_Code_IO is new Ada.Text_IO.Enumeration_IO( Play_Code );
   package Outcome_Code_IO is new Ada.Text_IO.Enumeration_IO( Outcome_Code );
   -- Gets a pair of codes for their play and your desired outcome, returns false if end of file
   function Get_Codes ( Their_Play_Code : out Play_Code; Desired_Outcome : out Outcome_Code ) return Boolean is
   begin
      Play_Code_IO.Get( Their_Play_Code );
      Outcome_Code_IO.Get( Desired_Outcome );
      return true;
   exception
      when E : End_Error => return false;
   end Get_Codes;
begin
   declare
      Their_Play_Code : Play_Code;
      Desired_Outcome_Code : Outcome_Code;
      
      Their_Play : Play;
      Desired_Outcome : Outcome;
      
      Total_Score : Score := 0;
   begin
      while Get_Codes( Their_Play_Code, Desired_Outcome_Code ) loop --out, out
         Their_Play := Play_Code_Map( Their_Play_Code );
         Desired_Outcome := Outcome_Code_Map( Desired_Outcome_Code );
         Total_Score := Total_Score + Play_Score( Required_Play( Their_Play, Desired_Outcome ) ) + Outcome_Score( Desired_Outcome );
      end loop;
      
      Score_IO.Put( Total_Score );
   end;
end Day2Part2;
