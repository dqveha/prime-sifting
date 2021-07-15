#num = 15
def prime(num)
  array = (2..num).to_a
  for element in (2..num)
    temp = element
    while temp < num 
      temp += element
      array.delete(temp)
    end
  end
  return array
end






# co-authored-by: Andrew Giang <giang184@gmail.com>
# Co-authored-by: Arthur Lee <meleearthur@gmail.com>
# Co-authored-by: Araceli Valdovinos <valdovinosaraceli50@gmail.com>"
# co-authored-by: Kristen Hopper <hopperdavis@gmail.com>
# co-authored-by: Adrian Camacho <adriancamacho18@gmail.com>