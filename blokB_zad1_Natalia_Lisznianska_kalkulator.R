kalkulator = function(a, b, operacja) {
  if (operacja == "+") {
    return(a+b)
  } else if (operacja == "-") {
    return(a-b)
  } else if (operacja == "*") {
    return(a*b)
  } else if (operacja == "/") {
    if ( b==0 ) {
      return("Błąd: dzielenie przez zero!")
    } else {
      return(a/b)
    }
  } else{
    return("Nieznana operacja")
  }
}


kalkulator(20, 2, "+")
kalkulator(20, 2, "-")
kalkulator(20, 2, "*")
kalkulator(20, 2, "/")
kalkulator(15, 0, "+")
kalkulator(15, 0, "-")
kalkulator(15, 0, "*")
kalkulator(15, 0, "/")

