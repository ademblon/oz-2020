functor
import
   Dict at x-oz://system/adt/Dictionary.ozf
export
   PutDict
   IterListDict
define
   
   fun{PutDict A Dict}
      case A
      of Arg|Mot|nil then
	 try 
	    Dict1 = {Dict.get Arg}
	    try
	       Valu = {Dict1.get Mot}
	       NewV = Valu + 1
	       {Dict1.put Mot NewV}
	    catch X then
	       {Dict1.put Mot 1}
	    end
	 catch Y then
	    Dict1 = {Dictionary.new}
	    {Dict1.put Mot 1}
	    {Dict.put Arg Dict1}
	 end
      else skip
      end
   end
   fun{IterListDict N Dic}
      case N
      of A|T then
	 {PutDict A Dict}
	 {IterListDict T Dic}
      [] nil then skip
      else skip end
   end
   
end


	    
	    

