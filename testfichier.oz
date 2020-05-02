declare A B C D E F G H I Z
A = "truc much"|"ez"|nil
B = "truc much"|"ez"|nil
C = "truc much"|"tri"|nil
D = "bla bla"|"bed"|nil
E = "bla bla"|"zeg"|nil
F = A|B|C|D|E|nil
{Browse 1}



class Dico2
   attr i
   meth init
      i := {Dictionary.new}
   end
   meth iterListDict(N)
      local
         proc{PutDict A Dicte}
	    local
	       Valu Dict1 K
	    in
	       case A
	       of Arg|Mot|nil then
		  K = {Dictionary.new}
	          Dict1 = {Dictionary.condGet Dicte {String.toAtom Arg} K}
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
      in
         case N
         of A|T then
	    {PutDict A @i}
	    {IterListDict T @i}
         [] nil then skip
	 else skip end
      end
   end
   meth filterAll(A) 
      local
         B 
	 proc{Iterfilter A Dicta Dicts}
	    local 
	       C
	       fun{FindMax Dicte}
		  local 
		     A
		     fun{Itermax A Dicty B U}
		        local 
			   C 
			in
			   case A of D|T then
			      C = {Dictionary.get Dicty D}
			      if C > U then {Itermax T Dicty D C}
			      else {Itermax T Dicty B U} end
			   [] nil then B end
			end
		     end
		  in
		     A = {Dictionary.keys Dicte}
		     {Itermax A Dicte {String.toAtom "init"} 0}
		  end
	       end
	    in
	       case A of D|T then
	          C = {Dictionary.get Dicta D}
		  {Dictionary.put Dicts D {FindMax C}}
		  {Iterfilter T Dicta Dicts}
	       []nil then skip end
	    end
	 end
      in
         B = {Dictionary.keys @i}
	 {Browse B}
	 A = {Dictionary.new}
	 {Iterfilter B @i A}
      end
   end
   meth get(LI X)
      {Dictionary.get @i {String.toAtom LI} X}
   end
   meth add1(LI B)
      {Dictionary.put @i {String.toAtom LI} B}
   end
end
G = {New Dico2 init}
{G iterListDict(F)}
{G filterAll(H)}
{Browse {Dictionary.get H {String.toAtom "truc much"}}}

proc {StartThreads Dico}
   local
      proc{Thread Dico N}
	 if N > 0 then
	    local
	       A
	    in
	       thread{ReadAllFiles N Dico} A = 1 end
	       A|{Thread Dico N-1}
	    end
	 else
	    nil
	 end
      end
      proc{Recup ListT}
	 for X in ListT do
	    {Wait X}
	 end
      end
   in
      {Recup {Thread Dico NThread}}
   end
end

      
		    
		
	 
   



	    
	    

