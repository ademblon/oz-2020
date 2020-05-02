functor
import
    QTk at 'x-oz://system/wp/QTk.ozf'
    System
    Application
    OS
    Browser
    Reader
	
define
%%% Easier macros for imported functions
    Browse = Browser.browse
    Show = System.show
	
%%%Dico
	Dico = {Reader.newactive Reader.dico2 init}
	FilteredDico = {NewCell Dico}

%%% Read File

	fun{Last2W L}
		case L
		of M|N|O|P then {Last2W (N|O|P)}
		[] N|O|nil then {Reader.cont N O}
		else nil
		end
	end
	
	fun {TwoLastWord Text}
		{Last2W {Reader.split Text}}
	end
	
    fun {AddWord Text}
       local TwoWords X in
			TwoWords = {TwoLastWord Text}
			{Dictionary.get @FilteredDico {String.toAtom TwoWords}}
		end
    end

    proc {LoadFiles}
		{Reader.startthreads Dico} %%%Load Files
		{Text2 set(1:"Files Loaded")}
    end
	
	proc{LoadDico}
		local X in
			{Dico filterAll(X)}
			FilteredDico := X
			{Text2 set(1:"Dico Loaded")}
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
    Text1 Text2 Description=td(
        title: "Frequency count"
        lr(
            text(handle:Text1 width:28 height:5 background:white foreground:black wrap:word)
	   button(text:"Load Files" action:LoadFiles)
	   button(text:"Add 1" action:AddTest)
	   button(text:"Load Dico" action:LoadDico)
        )
        text(handle:Text2 width:28 height:5 background:black foreground:white glue:w wrap:word)
        action:proc{$}{Application.exit 0} end % quit app gracefully on window closing
    )
   	
    proc {AddTest} Inserted NewWord in
       Inserted = {Text1 getText(p(1 0) 'end' $)}
       NewWord = {AddWord Inserted}
	   {Browse Inserted}
	   {Browse {Reader.filt Inserted}}
	   {Browse NewWord}
	   {Browse {AtomToString NewWord}}
	   {Browse {Conca Inserted NewWord}}
       {Text1 set(1:"")} % you can get/set text this way too
	   {Text1 tk(insert 'end' {Conca Inserted NewWord})}
    end
    % Build the layout from the description
    W={QTk.build Description}
    {W show}

    %{Text1 tk(insert 'end' {GetFirstLine "tweets/part_1.txt"})}

    {Show 'You can print in the terminal...'}
    {Browse '... or use the browser window'}
end
