functor
import
    Open
	Browser
export
    textfile:TextFile
	startthreads:StartThreads

define
%-----------------FILE HANDELING-------------------
	NThread = 2
    % Process lines
    % @pre: - InFile: a TextFile from the file
    %     
    % @post: Process every line of the file
	proc {Scan2 InFile}
		Line={InFile getS($)}
		ListWord
	in
		if Line==false then
			{InFile close}
		else
			%%%handle Line
			{Browser.browse {String.toAtom Line}}
			ListWord = {Split Line}
			{Scan2 InFile}
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
	
	proc {GetAllLine NAME}
		{Scan2 {New TextFile init(name:NAME)}}
	end
	
	proc{ReadAllFiles Num}
		local Name in
			Name = {CreateName Num}
			try
			{GetAllLine Name}
			{ReadAllFiles Num+NThread}
			catch X then skip
			end
		end
	end
	
	proc{StartThreads}
		for X in 1..NThread do
			thread{ReadAllFiles X}end
		end
		{Browser.browse {String.toAtom "A"}}
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
	
	fun{Split Str}
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
			@Y
		end
	end
	
%-------------- DICTIONARY --------------------------------------

end