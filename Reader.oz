functor
import
    Open
	Browser
export
    textfile:TextFile
	startthreads:StartThreads
	dico2:Dico2
	newactive:NewActive
	split:Split
	cont:Cont
	filt:Filt

define
%-----------------FILE HANDELING-------------------
	NThread = 8
    % Process lines
    % @pre: - InFile: a TextFile from the file
    %     
    % @post: Process every line of the file
	proc {Scan2 InFile Dico}
		Line={InFile getS($)}
		ListWord
		GroupWord
	in
		if Line==false then
			{InFile close}
		else
			%%%handle Line
			ListWord = {Split Line}
			GroupWord = {Group ListWord}
			{Dico iterListDict(GroupWord)}
			{Scan2 InFile Dico}
		end
	end
	
	fun {CreateName Num}
		local A B in
			A = {Append "tweets/part_" {Int.toString Num}}
			B = {Append A ".txt"}
			B
		end
	end

    class TextFile % This class enables line-by-line reading
        from Open.file Open.text
    end
	
	proc {GetAllLine NAME Dico}
		{Scan2 {New TextFile init(name:NAME)} Dico}
	end
	
	proc{ReadAllFiles Num Dico}
		local Name in
			Name = {CreateName Num}
			try
			{GetAllLine Name Dico}
			{ReadAllFiles Num+NThread Dico}
			catch X then {Browser.browse {String.toAtom {Cont "Thread finished : " {Int.toString (Num mod NThread)}}}}
			end
		end
	end
	
	proc{StartThreads Dico}
		for X in 1..NThread do
			thread{ReadAllFiles X Dico}end
		end

	end
	
%--------------- LINE PROCESSING ----------------------------------------------

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
	
	%Cree une liste de mot a partir d'un string
	fun {Split Str}
		local X Y in
			X = {NewCell ""}
			Y = {NewCell nil}
			for Lettre in {Filt Str} do
				if Lettre == 32 then
					Y := {Append (@X)|nil @Y}
					X := ""
				else
					X := {Append @X Lettre|nil}
				end
			end
			Y := {Append (@X)|nil @Y}
			{List.reverse @Y}	
		end
	end
	
	fun{Cont StrA StrB}
		local A B in
			A = {Append StrA " "}
			B = {Append A StrB}
			B
		end
	end
	
	%prend une liste et les regroupes
	fun{Group L}
		case L
		of M|N|O|P then ({Cont M N}|O|nil)|{Group (N|O|P)}
		[] M|N|O|nil then ({Cont M N}|O|nil)|nil
		else nil
		end
	end
	
%-------------- DICTIONARY --------------------------------------
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
	 A = {Dictionary.new}
	 {Iterfilter B @i A}
      end
   end
   meth get(LI X)
      {Dictionary.condGet @i {String.toAtom LI} "BUG" X}
   end
   meth add1(LI B)
      {Dictionary.put @i {String.toAtom LI} B}
   end
end
end

