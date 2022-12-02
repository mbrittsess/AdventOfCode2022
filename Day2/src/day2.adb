with Ada.Text_IO; use Ada.Text_IO;

procedure Day2 is
   type Play is ( Rock, Paper, Scissors );
   type Outcome is ( Loss, Draw, Win );

   type Score is range 0 .. Integer'Last;
   Total_Score : Score := 0;
   package Score_IO is new Integer_IO(Score);

   Play_Score : constant array( Play ) of Score := ( Rock => 1, Paper => 2, Scissors => 3 );
   Outcome_Score : constant array( Outcome ) of Score := ( Loss => 0, Draw => 3, Win => 6 );

   type Their_Code is ( A, B, C );
   Their_Code_Map : constant array( Their_Code ) of Play := ( Rock, Paper, Scissors );
   package Their_Code_IO is new Ada.Text_IO.Enumeration_IO( Their_Code );

   type Your_Code is ( X, Y, Z );
   Your_Code_Map : constant array( Your_Code ) of Play := ( Rock, Paper, Scissors );
   package Your_Code_IO is new Ada.Text_IO.Enumeration_IO( Your_Code );

   Rules : constant array ( Play, Play ) of Outcome := (-- Your play, their play, your outcome
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

   function Game_Score ( Yours, Theirs : Play ) return Score is
      Result : Outcome := Rules( Yours, Theirs );
   begin
      return Play_Score( Yours ) + Outcome_Score( Result );
   end Game_Score;

   function Game_Score ( Yours : Your_Code; Theirs : Their_Code ) return Score is
   begin
      return Game_Score( Your_Code_Map(Yours), Their_Code_Map(Theirs) );
   end Game_Score;
begin
   io_loop: loop
      declare
         Their_Play_Code : Their_Code;
         Your_Play_Code : Your_Code;
      begin
         Their_Code_IO.Get(Their_Play_Code); --out
         Your_Code_IO.Get(Your_Play_Code); --out
         Total_Score := Total_Score + Game_Score( Your_Play_Code, Their_Play_Code );
      exception
         when E : End_Error => exit io_loop;
      end;
   end loop io_loop;

   Score_IO.Put(Total_Score);
end Day2;
