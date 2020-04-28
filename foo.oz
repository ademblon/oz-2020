declare A B C
fun{Tri L}
   case L
   of M|N|O|P then (M|N|O|nil)|{Tri (N|O|P)}
   [] M|N|O|nil then (M|N|O|nil)
   else nil
   end
end
A = 1|2|3|4|5
B = {Tri A}
{Browse B}