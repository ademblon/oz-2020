functor
import
    Open
	Browser
export
	startthreads:StartThreads
	dico2:Dico2
	newactive:NewActive
	split:Split
	cont:Cont
	filt:Filt

define
%-----------------FILE HANDELING-------------------
	NThread = 8 %variable globale qui affiche le nombre de thread utilisé
	NBFiles = 208 %variable globale qui affiche lenombre de fichier à lire
	
    % Process lines
    % @pre: - InFile, Dico: un des fichiers text contenant les tweets, et une instance de Dico2 dans un objet actif
    %     
    % @post: remplis le dictionnaire avec lesdonnées
	proc {Scan2 InFile Dico}
		Lines
		ListWord
		GroupWord
	in
		{InFile read(list:Lines size:all)}
			ListWord = {Split Lines}
			GroupWord = {Group ListWord}
			{Dico iterListDict(GroupWord)}
		{InFile close}
	end
	
	% @pre: - Num: un numero correspondant à un fichier text
    %     
    % @post: un String contenant le nom du fichier numero Num.
	fun {CreateName Num}
		local A B in
			A = {Append "tweets/part_" {Int.toString Num}}
			B = {Append A ".txt"}
			B
		end
	end
	
	% @pre: - Name, Dico: le nom d'un fichier text, et une instance d'un Dico2 dans un objet actif
    %     
    % @post: applique la fonction Scan2 en utilisant CreateName.
	proc {GetAllLine NAME Dico}
		{Scan2 {New Open.file init(name:NAME)} Dico}
	end
	
	
	% @pre: - Num, Dico: Un numero de dossier de tweet à lire, et une instance d'un Dico2 dans un objet actif
    %     On note que la fonction est récursive terminale. En effet, la fonction lancée avec Num = k va en fait lire tout les fichier dont le numéro vaut k + NThread*n (avec n entier), cela permet de distribuer les fichier entre les Threads
    % @post: va lire plusieurs fichiers de tweet et remplir la base de donnée
	proc{ReadAllFiles Num Dico}
		local Name in
			if NBFiles >= Num then 
			   Name = {CreateName Num} 
			   {GetAllLine Name Dico}
			   {ReadAllFiles Num+NThread Dico}
			else
			   {Browser.browse {String.toAtom {Cont "Thread finished : " {Int.toString (Num mod NThread)+1}}}}
			end
		end
	end
	
	
	% @pre: - Dico: une instance d'un Dico2 dans un objet actif.
    %     
    % @post: la fonction va attribuer les fichiers aux différents Threads, et affiche l'instant de démarrage de chaque thread.
	proc{StartThreads Dico}
		for X in 1..NThread do
			{Browser.browse {String.toAtom {Cont "Thread starting : " {Int.toString X}}}}
			thread{ReadAllFiles X Dico}end
		end
	end
	
%--------------- LINE PROCESSING ----------------------------------------------
    % @pre: - Class, Init: une classe dont l'objet actif va être l'instance, avec sa valeur d'initialisation. 
    %     NewActive va servir à contenir la classe Dictio2définie plus bas, pour que celle-ci puisse être utilisée par plusieurs thread sans risque de bug.
    % @post: renvoie une fonction anonyme qui permet d'envoyer des instructions à l'instance de la classe.
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
					if {And Ch>=97 122>=Ch} then X := {Append @X Ch|nil}
					elseif Ch == 32 then X := {Append @X Ch|nil}
					else skip end
				end
			end
			@X
		end
	end
	
	% @pre: - Str: un String qui contient une phrase d'un des tweets
    %     
    % @post: une liste qui contient les mots de cette phrase sans majuscule.
	fun {Split Str}
		local X Y in
			X = {NewCell ""}
			Y = {NewCell nil}
			for Lettre in Str do 
				if {And Lettre == 32 @X \= nil} then
					Y := {Append (@X)|nil @Y}
					X := ""
				else
					local Ch={Char.toLower Lettre} in 
						if {And Ch>=97 122>=Ch} then X := {Append @X Ch|nil} else skip end
					end
				end
			end
			Y := {Append (@X)|nil @Y}
			{List.reverse @Y} %make it way faster
		end
	end
	
	% @pre: - StrA, StrB: deux mots sous forme de string.
    %     
    % @post: un String, qui est le résultat de la fusion des deux entrées, avec un espace entre 
	fun{Cont StrA StrB}
		local A B in
			A = {Append StrA " "}
			B = {Append A StrB}
			B
		end
	end
	
	% @pre: - L: une liste de mot.
    %     
    % @post: une liste de sous liste de taille deux qui contient les données sous un format adapté au dictionnaire de stockage
	fun{Group L}
		case L
		of M|N|O|P then ({Cont M N}|O|nil)|{Group (N|O|P)}
		else nil
		end
	end
	
%-------------- DICTIONARY --------------------------------------
	%La classe Dico2 est une classe qui va être utilisée dans la fonction newactive, elle a une variable interne, qui est un dictionnaire.
	%Ce dictionnaire a pour clé l'ensemble des paires de mots extrait des tweet, et a pour contenu un autre dictionnaire qui contient les troisièmes mots possibles, avec leurs occurences dans les tweets.
    %La classe contient la méthode iterListDict qui prend une liste en entrée et remplis le dictionnaire interne avec ces données. La méthode FilterAll quant à elle, va filtrer le dictionnaire interne, et va renvoyer un dictionnaire qui contiendra uniquement les paires de mots possibles	avec comme valeurs le mots qui suit ayant eu le plus d'occurence.
	
	class Dico2
   attr i
   meth init
      i := {Dictionary.new}
   end
    % @pre: - N: liste contenant des sous listes de taille deux, le premier élément de cette sous liste est une paire de mot, et le deuxième est le mots qui suit dans le tweet.
    %     
    % @post: stocke les données dans le dictionnaire interne
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
    % @pre: - traite le dictionnaire contenant les données brutes, pour ne garder que le mot contenant le plus d'occurence
    %     
    % @post: renvoie ce nouveau dictionnaire, à noter que c'est une instance du dictionnaire de base, et pas de Dictio2
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

