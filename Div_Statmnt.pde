class DivisionStatement{
  Polynomial quotient, remainder, divisor;
  //Q is the quotient
  //R is the remainder
  //D is the divisor
  
  //thus, it is of the form Q + R/D
  DivisionStatement(Polynomial q, Polynomial r, Polynomial d, color col){
    this.quotient = new Polynomial(q.terms, col);
    this.remainder = new Polynomial(r.terms, col);
    this.divisor = new Polynomial(d.terms, col);
  }
  
  String getDivisionStatementString(){
    return this.quotient.getFunctionString() + " + (" + this.remainder.getFunctionString() + ")/(" + this.divisor.getFunctionString() + ")";
  }
}
