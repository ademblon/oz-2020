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
{Browse 8}
{Browse B}
{A get("hello" C)}
{Browse B}
{Browse 9}
{Browse C}

declare A B C D
A = {NewDictionary}
D = test
%C = {String.toAtom D}
{Dictionary.put A D 1}
{Dictionary.get A D B}
{Browse B}


declare A B C
fun{Filt Str}
   local X in
      X = {NewCell ""}
      for Lettre in Str do
	 local Ch in
	    Ch = {Char.toLower Lettre}
	    if Ch>=97 then X := {Append @X Ch|nil}
	    elseif Ch == 32 then X := {Append @X Ch|nil}
	    else skip end
	 end
      end
      @X
   end
end
proc{Split Str Z}
   local X Y in
      X = {NewCell ""}
      Y = {NewCell nil}
      for Lettre in {Filt Str} do
	 if Lettre == 32 then
	    Y := {Append @Y (@X)|nil}
	    X := ""
	 else
	    X := {Append @X Lettre|nil}
	 end
      end
      Z = @Y
   end
end
A = "AAA. BBB;? C,CC D??DD "
{Split A B}
{Browse  B}

declare A B C D E F G H I
A = "truc much"|"ez"|nil
B = "truc much"|"ez"|nil
C = "truc much"|"tri"|nil
D = "bla bla"|"bed"|nil
E = "bla bla"|"zeg"|nil
F = A|B|C|D|E|nil
G = {Dictionary.new}
proc{PutDict A Dicte}
   local
      Valu Dict1
   in
      case A
      of Arg|Mot|nil then
	 Dict1 = {Dictionary.condGet Dicte {String.toAtom Arg} {Dictionary.new}}
	 Valu = {Dictionary.condGet Dict1 {String.toAtom Mot} 0}
	 {Dictionary.put Dict1 {String.toAtom Mot} Valu+1}
	 {Dictionary.put Dicte {String.toAtom Arg} Dict1}
      else skip end
   end
end
proc{IterListDict N Dic}
   case N
   of A|T then
      {PutDict A Dic}
      {IterListDict T Dic}
   [] nil then skip
   else skip end
end

fun{FindMax Dicte}
   local A
      fun{Itermax A Dicte B U}
	 local C in
	    case A of D|T then
	       C = {Dictionary.get Dicte D}
	       if C > U then {Itermax T Dicte D C}
	       else {Itermax T Dicte B U} end
	    [] nil then B end
	 end
      end
   in
      A = {Dictionary.keys Dicte}
      {Itermax A Dicte {String.toAtom "init"} 0}
   end
end

fun{FilterAll Dictu}
   local B A
      proc{Iterfilter A Dicte Dicts}
	 local C in
	    case A of D|T then
	       C = {Dictionary.get Dicte D}
	       {Dictionary.put Dicts D {FindMax C}}
	       {Iterfilter T Dicte Dicts}
	    []nil then skip end
	 end
      end
   in
      B = {Dictionary.keys Dictu}
      {Browse B}
      A = {Dictionary.new}
      {Iterfilter B Dictu A}
      A
   end
end
{IterListDict F G}
H = {FilterAll G}
{Browse {Dictionary.keys H}}
{Browse {Dictionary.get H {String.toAtom "truc much"}}}


   


	  
      
      
   
      


      
	 
	 
	 