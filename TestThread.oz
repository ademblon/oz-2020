declare NThread A B C
% Fetches the N-th line in a file
% @pre: - InFile: a TextFile from the file
%- N: the desires Nth line
%@post: Returns the N-the line or 'none' in case it doesn't exist
NThread = 2
A = "D:/Programmation/Projects/oz-2020/tweets/part_1.txt"
proc {Scan2 InFile N}
   Line={InFile getS($)}
in
   if Line==false then
      {InFile close}
   else
      {Browse N}
      {Scan2 InFile N+1}
   end
end
class TextFile % This class enables line-by-line reading          
   from Open.file Open.text
end
proc {GetAllLine NAME Num}
   {Scan2 {New TextFile init(name:NAME)} Num}
end
fun {CreateName Num}
   local A B in
      A = {Append "tweets/part_" {Int.toString Num}}
      B = {Append A ".txt"}
      B
   end
end
%{Browse {GetFirstLine "tweets/part_1.txt"}}
{GetAllLine A 0}
%{ReadFile "tweets/part_1.txt" }

      
   
   

