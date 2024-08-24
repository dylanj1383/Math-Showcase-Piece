class Polynomial extends Function{
  int degree;
  PolynomialTerm[] terms;
  
  //create a polynomial in standard form given the degree and coefficients
  Polynomial(int degree, float[] coefficients, color col){
    super("polynomial", col);
    this.degree = degree;
    this.terms = new PolynomialTerm[degree+1];
    
    int d = degree;
    PolynomialTerm currentTerm;
    while (d >= 0){
      try{
        currentTerm = new PolynomialTerm(coefficients[this.degree - d], d);
        this.terms[this.degree - d] = currentTerm;
      } 
      catch (Exception e){
        this.terms[this.degree - d] = new PolynomialTerm(0, d);
      }
      d--;
    }
  }
  
  //create a polynomial in standard form given the degree and an arrayList of terms
  Polynomial(PolynomialTerm[] givenTerms, color col){
    super("polynomial", col);
    
    ArrayList<PolynomialTerm> newTerms = new ArrayList<PolynomialTerm>();
    
    for(int currentDegree = findMaxDegree(givenTerms); currentDegree >= 0; currentDegree --){
      float currentCoefficient = 0;
      for(int i = 0; i<givenTerms.length; i++){
        PolynomialTerm checkTerm = givenTerms[i];
        if (checkTerm.degree == currentDegree){
          currentCoefficient += checkTerm.coefficient;
        }
      }
      if ( !(currentCoefficient==0 && newTerms.size() == 0) ) {
        newTerms.add(new PolynomialTerm(currentCoefficient, currentDegree));
      }
    }
    if(newTerms.size() == 0){
      //exception - the polynomial evaluates to 0
      newTerms.add(new PolynomialTerm(0, 0));
    }
    
    //fill the array of terms from the arrayList newTerms
    PolynomialTerm[] endTerms = new PolynomialTerm[newTerms.size()];
    for (int i = 0; i < newTerms.size(); i++){
      endTerms[i] = newTerms.get(i);
    }
    this.terms = endTerms;
    this.degree = findMaxDegree(this.terms);
  }
  
  //creates a polynomial in standard form given an arrayList of factors
  Polynomial(Polynomial[] factors, color col){
    super("polynomial", col);
    
    Polynomial result = new Linear(0, 1);
    
    for (Polynomial factor : factors){
      result = result.multiplyWith(factor);
    }
    
    this.degree = result.degree;
    this.terms = result.terms;
  }
  
  //creates a polynomial in standard form given an arrayList of factors and a leading coefficient
  Polynomial(Polynomial[] factors, float a, color col){
    super("polynomial", col);
    
    Polynomial result = new Linear(0, a);
    
    for (Polynomial factor : factors){
      result = result.multiplyWith(factor);
    }
    
    this.degree = result.degree;
    this.terms = result.terms;
  }
  
  //creates a polynomial in standard form given string of factors
  Polynomial(String isFactored, String inString, color col){
    //the string isFactored is just to differentiate this constructor from the one below
    
    //input specifications
    //e.g. "(5x + 2)(3x^2 + 10)(4x-1)(x)(-23)()"
    //all factors should be surrounded by rounded parenthesis (not {} or [])
    //anything between pairs of parenthesis will be ignored and not read (e.g. you can't do (4x + 2) + (4x - 2)
    //there should be no nested parenthesis. That is, an open bracket should never be followed by another open parenthesis if there is no close parenthesis between them
    //each open parenthesis should be paired with a close parenthesis
    
    
    super("polynomial", col);
    
    ArrayList<Polynomial> foundFactors = new ArrayList<Polynomial>();
    
    
    String lookingFor = "open bracket";
    String thisPolynomialString = "";
    Polynomial p = null;
    //iterate through inString and extract anything between two parentheses
    for (int i = 0; i<inString.length(); i++){
      char thisChar = inString.charAt(i);
      
      if (lookingFor.equals("open bracket")){
        if (thisChar == '('){
          //we want to start recording the polynomial
          thisPolynomialString = "";
          lookingFor = "close bracket";
        }
        
      }
      else if (lookingFor.equals("close bracket")){
        if (thisChar == ')'){
          //we want to make a polynomial with whatever is in thisPolynomial
          try {
            p = new Polynomial(thisPolynomialString, col);
          } 
          catch (Exception e){
            println("The factor", thisPolynomialString, "is not valid");
            raiseErrorWithoutAssert();
          }
          
          if (p != null){
            foundFactors.add(p);
          }
          
          thisPolynomialString = "";
          lookingFor = "open bracket";
        }
        else{
          thisPolynomialString += thisChar;
        }
      }
    }
    
    Polynomial[] foundFactorsArray = new Polynomial[foundFactors.size()];
    for (int i = 0; i<foundFactors.size(); i++){
      foundFactorsArray[i] = foundFactors.get(i);
    }
    
    Polynomial thisThing = new Polynomial(foundFactorsArray, col);
    this.degree = thisThing.degree;
    this.terms = thisThing.terms;
  }
  
  //creates a polynomial in standard form given a string in standard form
  Polynomial(String inString, color col){
    super("polynomial", col);
    //input specificiations:
    //e.g. "5x^2 + 3x^2 - 3x + 16x^1 + 7x^0 - 8"
    //1. each term is separated by either + or -
    //2. all exponents, if present, should be preceted by a "x^"
    //3. all exponents should be integers larger than or equal to 0
    //4. an exponent of 1 is not necessary, but could be added if wanted (e.g. 5x or 5x^1)
    //5. an exponent of 0 is not necessary (you don't need to add the x), but could be added if wanted (e.g. 5 or 5x^0)
    //6. exponents should not have a + or - in front of them; +/- should only be used to separate terms.
    
    //remove any spaces
    // "5x^2 + 3x^2 - 3x + 16x^1 + 7x^0 - 8" --> "5x^2+3x^2-3x+16x^1+7x^0-8"
    inString = removeSpaces(inString);
    
    //if the string "^-" or "^+" occurs in inString, the user has violated #6
    if (inString.indexOf("^-") != -1 || inString.indexOf("^+") != -1){
      println("Exponents must not have a sign in front of them");
      raiseErrorWithoutAssert();
    }
     
    //breakup inString into its terms. Then we can create term objects form the termStrings and add them to foundTerms
    ArrayList<PolynomialTerm> foundTerms = new ArrayList<PolynomialTerm>();
    String thisTermString = "";
    PolynomialTerm t;
    //do this by iterating through every character in inString.
    for(int i = 0; i<inString.length(); i++){
      char thisChar = inString.charAt(i);
      if (thisChar == '+' || thisChar == '-' || i == inString.length()-1){
        if (i == inString.length()-1){
          thisTermString += thisChar;
        }
        
        
        //we are making a new term. We need to convert what is currently in thisTermsString into a term, add it to foundTerms, and then we can reset thisTermString
        try{
          t = new PolynomialTerm(thisTermString);
        }
        catch (Exception e){
          //the term we are checking is invalid and could not be created (we raised an assertion error in the constructor for PolynomialTerm)
          println("The term", thisTermString, "is invalid.");
          raiseErrorWithoutAssert();
          return;
        }
        
        //t must be a valid term. Add t to foundTerms
        foundTerms.add(t);
        thisTermString = "";
      }
      
      
      thisTermString += thisChar;
      
    }
    
    //make a new polynomial from found terms
    PolynomialTerm[] foundTermsArray = new PolynomialTerm[foundTerms.size()];
    for (int i = 0; i < foundTerms.size(); i++){
      foundTermsArray[i] = foundTerms.get(i);
    }
    
    Polynomial thisThing = new Polynomial(foundTermsArray, col);
    this.degree = thisThing.degree;
    this.terms = thisThing.terms;
  }
  
  Float f(float x){
    raiseErrorWithoutAssert( this.terms.length == this.degree + 1 );
    float sum = 0;
    for (PolynomialTerm t : this.terms){
      sum+= t.getValue(x);
    }
    return sum;
  }
  
  float[] xInts(){
    return this.solveReals();
  }
  
  Polynomial addPolynomial(Polynomial other){
    //add this with other and return the resulting polynomial
    PolynomialTerm[] t1 = this.getTermsCopy();
    PolynomialTerm[] t2 = other.getTermsCopy();
    PolynomialTerm[] together = addTermArrays(t1, t2);
    return new Polynomial(together, this.col);
  }
  
  Polynomial subtractPolynomial(Polynomial other){
    return this.addPolynomial(other.multiplyAllTermsBy(-1));
  }
  
  Polynomial[] factor(){
    ArrayList<Polynomial> factors = new ArrayList<Polynomial>(); //this will store all our factors
    Polynomial toBeFactored = this;
    

    int maxDps = maxNumDecimalPlaces(toBeFactored.terms);
    //make sure all the coefficients are integers by multiplying all of them by 10^maxDps
    toBeFactored = toBeFactored.multiplyAllTermsBy(pow(10, maxDps));
    //common factor will be 10^-maxDps
    float commonFactor = pow(10, -maxDps);
    //remove any additional common factors that could remain from making coefficients integers
    int gcd = gcd(toBeFactored);
    commonFactor *= gcd;
    toBeFactored = toBeFactored.multiplyAllTermsBy(1.0/gcd);
    
    //check all the values of +- p/q  (p is a factor of the constant term, q is a factor of the leading coefficient)
    boolean foundFactor = true;
    while (foundFactor) {
      foundFactor = false;
      float[] pOptions = getFactors(toBeFactored.terms[toBeFactored.terms.length-1].coefficient);
      float[] qOptions = getFactors(toBeFactored.terms[0].coefficient);
      int[] signOptions = {-1, 1};
      for (int sign : signOptions){ for (float p : pOptions){ for (float q : qOptions){
        float tryVal = sign * p/q;
        if (toBeFactored.f(tryVal) == 0){
          //then qx - p is a factor of toBeFactored
          Linear factor = new Linear(q, -1*sign*p);
          DivisionStatement result = toBeFactored.divideBy(factor);
          Polynomial rem = result.remainder;
          if (rem.degree == 0 && rem.terms[0].coefficient == 0){
            //the remainder should be 0 - add our factor to the list
            //set the new thing toBeFactored
            factors.add(result.divisor);
            toBeFactored = result.quotient;
            foundFactor = true;
          }
        }
      }}}
    }
    
    if (toBeFactored.terms[0].coefficient == 0 && toBeFactored.terms.length != 1){
      //dont add this factor - it is a monkey
    }else if(toBeFactored.terms[0].coefficient == 1 && toBeFactored.terms.length == 1){
      //dont add a remaining factor of 1
      if (commonFactor != 1){
        factors.add(0, new Constant(commonFactor));
      }
    }
    else{
      factors.add(toBeFactored);
    }
    
    
    
    Polynomial[] factorsArray = new Polynomial[factors.size()];
    for (int i = 0; i < factors.size(); i++){
      factorsArray[i] = factors.get(i);
    }
    
    
    return factorsArray;
  }
  
  Polynomial multiplyWith(Polynomial other){
    //for each term in this, multiply with each term in other
    ArrayList<PolynomialTerm> newTerms = new ArrayList<PolynomialTerm>();
    for (PolynomialTerm t : this.terms){
      //mult t by all the terms in other and add these terms to the list newTerms
      Polynomial result = other.multiplyAllTermsBy(t);
      
      //add all of the things in result.terms to newTerms
      //newTerms.addAll(result.terms);
      for (PolynomialTerm n : result.terms){
        newTerms.add(n);
      }
    }
    
    PolynomialTerm[] newTermsArray = new PolynomialTerm[newTerms.size()];
    for (int i = 0; i < newTerms.size(); i++){
      newTermsArray[i] = newTerms.get(i);
    }
    
    return new Polynomial(newTermsArray, this.col);
  }
  
  Polynomial multiplyAllTermsBy(float c){
    return this.multiplyAllTermsBy(new PolynomialTerm(c, 0));
  }
  Polynomial multiplyAllTermsBy(PolynomialTerm other){
    //multiply all the terms in this by other, and returns the resulting polynomial as a new object
    
    ArrayList<PolynomialTerm> newTerms = new ArrayList<PolynomialTerm>();
    
    for(PolynomialTerm t : this.terms){
      //multiply t with other, and add this result to the ArrayList newTerms
      newTerms.add(t.multWithTerm(other));
    }
    
    PolynomialTerm[] newTermsArray = new PolynomialTerm[newTerms.size()];
    for (int i = 0; i < newTerms.size(); i++){
      newTermsArray[i] = newTerms.get(i);
    }
    
    return new Polynomial(newTermsArray, this.col);
  }
  
  DivisionStatement divideBy(Polynomial other){
    //do the long division process
    
    ArrayList<PolynomialTerm> quotientTerms = new ArrayList<PolynomialTerm>();
    
    Polynomial divident = this;
    Polynomial divisor = other;
    
    if(divisor.degree == 0){
      Polynomial quotient = divident.divideAllTermsBy(other.terms[0]);
      Polynomial remainder = new Constant(0);
      return new DivisionStatement(quotient, remainder, divisor, this.col);
    }
    
   
    while(divident.degree >= divisor.degree){
      PolynomialTerm t1 = divident.terms[0];
      PolynomialTerm T1 = divisor.terms[0];
  
      //r = t1/T1;
      PolynomialTerm r = t1.divideByTerm(T1);
      quotientTerms.add(r);
      
      //multipy the polynomial divisor by r
      Polynomial n = divisor.multiplyAllTermsBy(r);
      
      //subtract n from the divident
      Polynomial k = divident.subtractPolynomial(n);
      //repeat. K is the new divident
      divident = k;
    }
    
    //the remainder is the remaining divident
    Polynomial remainder = divident;
    //the quotient is the terms found in quotientTerms
    
    PolynomialTerm[] quotientTermsArray = new PolynomialTerm[quotientTerms.size()];
    for (int i = 0; i<quotientTerms.size(); i++){
      quotientTermsArray[i] = quotientTerms.get(i);
    }
    
    Polynomial quotient = new Polynomial(quotientTermsArray, this.col);
    
    raiseErrorWithoutAssert ( (quotient.terms[0].coefficient != 0 || quotient.terms.length == 0) );
    
    return new DivisionStatement(quotient, remainder, divisor, this.col);
  }
  
  Polynomial divideAllTermsBy(float c){
    return this.divideAllTermsBy(new PolynomialTerm(c, 0));
  }
  Polynomial divideAllTermsBy(PolynomialTerm other){
    //divides all the terms in this by other, and returns the resulting polynomial as a new object
    
    ArrayList<PolynomialTerm> newTerms = new ArrayList<PolynomialTerm>();
    
    for(PolynomialTerm t : this.terms){
      //divide t by other, and add this result to the ArrayList newTerms
      if(t.coefficient!=0){
        newTerms.add(t.divideByTerm(other));
      }
    }
    
    PolynomialTerm[] newTermsArray = new PolynomialTerm[newTerms.size()];
    for (int i = 0; i < newTerms.size(); i++){
      newTermsArray[i] = newTerms.get(0);
    }
    return new Polynomial(newTermsArray, this.col);
  }
  
  String getFunctionString(){
    return getFunctionString(false, false);
  }
  
  String getFunctionString(boolean showUselessCoefficients, boolean showUselessExponents){
    String outStr = "";
    boolean firstTermMode = true; //whether or not you put a "+" in front of the term
    for (int i = 0; i<this.terms.length; i++){
      PolynomialTerm t = this.terms[i];
      
      if (!(t.coefficient == 0 && !showUselessCoefficients)){
        if(!firstTermMode && t.coefficient >= 0){
          outStr = outStr + "+";
        }
        outStr = outStr + t.getTermString(showUselessExponents, showUselessCoefficients)+ " ";
        firstTermMode = false;
      }
    }
    try{
      return outStr.substring(0, outStr.length()-1);
    }
    catch (Exception e){
      //if we have made an error, it means outStr is the empty string - only possible if the polynomial is 0
      return "0";
    }
  }
  
  String getFactoredFunctionString(){
    return getFactoredFunctionString(false, false);
  }
  String getFactoredFunctionString(boolean showUselessCoefficients, boolean showUselessExponents){
    String outStr = "";
    Polynomial[] factors = this.factor();
    
    for (Polynomial f : factors){
      outStr = outStr + "(" + f.getFunctionString(showUselessCoefficients, showUselessExponents) + ")";
    }
    
    return outStr;
  }
  
  Complex[] solve(){
    //returns an arrayList of all solutions found using the methods taught in grade 12
    ArrayList<Complex> solutions = new ArrayList<Complex>();
    
    
    Polynomial[] factors = this.factor();
    for (Polynomial factor : factors){
      if (factor.degree == 1){
       
        Linear linearFactor = factor.toLinear();
        
        if (linearFactor.m == 0){
          //dont add any solutions if the factor we are on is just a constant term
        }
        else{
          Complex[] linSols = linearFactor.solve();
          for (Complex linSol : linSols){
            if (!solutionAlreadyFound(solutions, linSol)){
              solutions.add(linSol);
            }
          }
        }
      }
      else if (factor.degree == 2){
        Quadratic quadraticFactor = factor.toQuadratic();
        Complex [] quadSols = quadraticFactor.solve();
        for (Complex quadSol : quadSols){
          if (!solutionAlreadyFound(solutions, quadSol)){
            solutions.add(quadSol);
          }
        }
      }
      else{
        //println("Extra solutions may exist");
      }
    }
    
    Complex[] solutionsArray = new Complex[solutions.size()];
    for (int i = 0; i<solutions.size(); i++){
      solutionsArray[i] = solutions.get(i);
    }
    return solutionsArray;
  }
  
  float[] solveReals(){
    Complex[] allSolutions = this.solve();
    ArrayList<Float> realSolutions = new ArrayList<Float>();
    for (Complex solution : allSolutions){
      if (solution.b == 0){
        //solution is real
        realSolutions.add(solution.a);
      }
    }
    
    float[] realSolutionsArray = new float[realSolutions.size()];
    for (int i=0; i<realSolutions.size(); i++){
      realSolutionsArray[i] = realSolutions.get(i);
    }
    realSolutionsArray = sort(realSolutionsArray);
    return realSolutionsArray;
  }
  
  PolynomialTerm[] getTermsCopy(){
    PolynomialTerm[] outList = new PolynomialTerm[this.degree+1];
    for (int i = 0; i < this.degree+1; i++){
      outList[i] = this.terms[i];
    }
    return outList;
  }
  
  Linear toLinear(){
    raiseErrorWithoutAssert( this.degree == 1 );
    float m, b;
    m = this.terms[0].coefficient;
    b = this.terms[1].coefficient;
    return new Linear(m, b, this.col);
  }
  
  Quadratic toQuadratic(){
    raiseErrorWithoutAssert( this.degree == 2 );
    float a, b, c;
    a = this.terms[0].coefficient;
    b = this.terms[1].coefficient;
    c = this.terms[2].coefficient;
    return new Quadratic(a, b, c, this.col);
  }
  
  boolean equals(Polynomial other){
    if (this.degree != other.degree){
      return false;
    }
    
    PolynomialTerm t1, t2;
    for (int i = 0; i<=degree; i++){
      t1 = this.terms[i];
      t2 = other.terms[i];
      if( !(t1.coefficient == t2.coefficient && t1.degree == t2.degree) ){
        return false;
      }
    }
    
    return true;
  }
  
}

class Linear extends Polynomial{
  float m, b; //mx + b
  Linear(float m, float b){
    super(1, new float[2], color(255));
    this.terms[0] = new PolynomialTerm(m, 1);
    this.terms[1] = new PolynomialTerm(b, 0);
    this.m=m;
    this.b=b;
  }
  
  Linear(float m, float b, color col){
    super(1, new float[2], col);
    this.terms[0] = new PolynomialTerm(m, 1);
    this.terms[1] = new PolynomialTerm(b, 0);
    this.m=m;
    this.b=b;
  }
  
  Complex[] solve(){
    //0 = mx + b
    //x = -b/m
    ArrayList<Complex> solutions = new ArrayList<Complex>();
    if(b != 0){
      solutions.add(new Complex(-1*b/m, 0));
    }
    else{
      solutions.add(new Complex(0, 0)); //avoid having it return something like "-0.0" instead of just "0.0" because of the way floats are stored
    }
    
    Complex[] solutionsArray = new Complex[solutions.size()];
    for (int i = 0; i<solutions.size(); i++){
      solutionsArray[i] = solutions.get(i);
    }
    
    return solutionsArray;
  }
  
  LOA toLOA(){
    return new LOA(this.m, this.b);
  }
}

class Constant extends Linear{
  Constant(float constant){
    super(0, constant);
  }
  Constant(float constant, color c){
    super(0, constant, c);
  }
  
  Complex[] solve(){
    //the solutions will either be no solutions or inifinte solutions - both of which are useless, so we return the empty array
    Complex[] solutions = new Complex[0];
    return solutions;
  }
}

class Quadratic extends Polynomial{
  float a, b, c;
  
  Quadratic(float aVal, float bVal, float cVal, color col){
    super(2, new float[3], col);
    this.terms[0] = new PolynomialTerm(aVal, 2);
    this.terms[1] = new PolynomialTerm(bVal, 1);
    this.terms[2] = new PolynomialTerm(cVal, 0);
    this.a = aVal;
    this.b = bVal;
    this.c = cVal;
  }
  
  Complex[] solve(){
    //x = ( -b +- sqrt(b*b - 4*a*c) ) / (2*a);
    float discriminant = this.b*this.b - 4*this.a*this.c;
    ArrayList<Complex> solutions = new ArrayList<Complex>();
    
    if (discriminant > 0){
      float x1 = ( -this.b - sqrt(discriminant) ) / (2*this.a);
      float x2 = ( -this.b + sqrt(discriminant) ) / (2*this.a);
      solutions.add(new Complex(x1, 0));
      solutions.add(new Complex(x2, 0));
    }
    else if (discriminant == 0){
      float x1 = ( -this.b ) / (2*this.a);
      solutions.add(new Complex(x1, 0));
    }
    else if (discriminant < 0){
      float posDisc = abs(discriminant);
      Complex c1 = new Complex(-this.b/(2*this.a), sqrt(posDisc)/(2*this.a));
      Complex c2 = new Complex(-this.b/(2*this.a), -sqrt(posDisc)/(2*this.a));
      solutions.add(c1);
      solutions.add(c2);
    }
    
    Complex[] solutionsArray = new Complex[solutions.size()];
    for (int i = 0; i<solutions.size(); i++){
      solutionsArray[i] = solutions.get(i);
    }
    
    return solutionsArray;
  }
}

class Complex{
  //a+bi;
  float a;
  float b; 
  
  Complex(float a, float b){
    this.a = a;
    this.b = b;
  }
  
  boolean equals(Complex other){
    return (this.a == other.a && this.b == other.b);
  }
}
