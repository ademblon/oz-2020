functor
import
    QTk at 'x-oz://system/wp/QTk.ozf'
    Application
    Browser
    Reader
	
define

%%%Dico
	Dico = {Reader.newactive Reader.dico2 init}
	FilteredDico = {NewCell Dico}

%%% Read File


	% @pre: - L: Une liste de mots
    %     
    % @post: renvoie une liste contenant les deux derniers éléments
	fun{Last2W L}
		case L
		of M|N|O|P then {Last2W (N|O|P)}
		[] N|O|nil then {Reader.cont N O}
		else nil
		end
	end
	
	% @pre: - Text : Un texte sous forme d'un string, contenant au moins 2 mots
	%
    % @post: Une liste contenant les deux derniers mots du texte
	fun {TwoLastWord Text}
		{Last2W {Reader.split Text}}
	end
	
	% @pre: - Text : Un texte sous forme d'un string, contenant au moins 2 mots
    %     
    % @post: renvoie le mot avec la plus grande occurence suivant les deux derniers mots
    fun {AddWord Text}
       local TwoWords in
			TwoWords = {TwoLastWord {Reader.filt Text}}
			{Dictionary.condGet @FilteredDico {String.toAtom TwoWords} {String.toAtom "Key not found"}}
		end
    end

    proc {LoadFiles}
		{Reader.startthreads Dico} %%%Load Files
    end
	
	proc{LoadDico}
		local X in
			{Dico filterAll(X)}
			FilteredDico := X
			{Browser.browse {String.toAtom "Dico Loaded"}}
		end
	end
	
	fun{Conca StrA StrB}
		local A B C in
			A = {Append {Reader.filt StrA} " "}
			B = {Append A {AtomToString StrB}}
			C = {Append B 10|nil}
			C
		end
	end
	
	


    
%%% GUI
    % Make the window description, all the parameters are explained here:
    % http://mozart2.org/mozart-v1/doc-1.4.0/mozart-stdlib/wp/qtk/html/node7.html)
    Text1 Description=td(
        title: "Frequency count"
        lr(
            text(handle:Text1 width:28 height:5 background:white foreground:black wrap:word)
	   button(text:"Load Files" action:LoadFiles)
	   button(text:"Load Dico" action:LoadDico)
	   button(text:"Add 1" action:AddTest)
        )
        action:proc{$}{Application.exit 0} end % quit app gracefully on window closing
    )
   	
    proc {AddTest} Inserted NewWord in
       Inserted = {Text1 getText(p(1 0) 'end' $)}
       NewWord = {AddWord Inserted}
       {Text1 set(1:"")} 
	   {Text1 tk(insert 'end' {Conca Inserted NewWord})}
    end
    % Build the layout from the description
    W={QTk.build Description}
    {W show}

end
