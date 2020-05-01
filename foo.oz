declare A B C
fun{Tri L}
   case L
   of M|N|O|P then (M|N|O|nil)|{Tri (N|O|P)}
   [] M|N|O|nil then (M|N|O|nil)
   else nil
   end
end
%A = 1|2|3|4|5
%B = {Tri A}
%{Browse B}



declare E F G
fun{NewActive Class Init}
   Obj={New Class Init}
   P
in
   thread S in
      {NewPort S P}
      for M in S do {Obj M} end
   end
   proc{$ M} {Send P M} end
end
class ListB
   attr i
   meth init
      i := nil
   end
   meth add(X)
      i := X|@i
   end
   meth get(X)
      X=@i
   end
end
E = a|b|c|nil
F = 1|2|3|nil
G = {NewActive ListB init}
proc {FullAdd Input Output}
   case Input
   of A|B then ({Output add(A)} {FullAdd B Output})
   [] A|nil then {Output add(A)}
   else skip
   end
end
thread {FullAdd E G} end
thread {FullAdd F G} end
local X in
   {G get(X)}
   {Browse X}
end

declare A B C
A = "Test"
B = " 1"
C = {Append A B}
{Browse C}


declare A B C
class Dico
   attr i
   meth init
      i := {Dictionary.new}
   end
   meth add(LI)
      X Y
   in
      {Dictionary.condGet @i {String.toAtom LI} 0 X}
      Y = X +1
      {Dictionary.put @i {String.toAtom LI} Y}
   end
   meth get(LI X)
      {Dictionary.get @i {String.toAtom LI} X}
   end
end
A = {New Dico init}
{A init}
{A add("test")}
{A add("test")}
{A add("hello")}
{A get("test" B)}
{A get("hello" C)}
{Browse B}
{Browse C}

declare A B C D
A = {NewDictionary}
D = test
%C = {String.toAtom D}
{Dictionary.put A D 1}
{Dictionary.get A D B}
{Browse B}

{Browse {Append (1|2|nil) (3|4|nil)}}

declare A B C
A = "AAA BBB CCC DDD "
proc{Test Str}
   local X in
      X = {NewCell ""}
      for Lettre in Str do
	 {Browse Lettre}
      end
      {Browse @X}
   end
end
{Test A}


proc{Mot Y Str}
   local Temp NewList in
   Temp = {NewCell ""}
   NewList = {NewCell nil} 
   for Lettre in Str do
      if Lettre == 32 then
	 NewList := {Append @NewList @Temp}
	 Temp := ""
      else
	 Temp := {Append @Temp Lettre}
      end
   else skip
   end
   y = @NewList
   end
end
{Mot B A}
{Browse B} 
   

   


	  
      
      
   
      


      
	 
	 
	 