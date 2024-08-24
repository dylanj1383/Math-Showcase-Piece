class Rational extends Function{
  Polynomial numerator;
  Polynomial denominator;
  Polynomial simplifiedNumerator;
  Polynomial simplifiedDenominator;
  ArrayList<PVector> holes;
  
  Rational(Polynomial n, Polynomial d){
    super("rational", n.col);
    this.numerator = n;
    this.denominator = d;
    this.setSimplifiedFunction(); //removes any holes
    
  }
  Rational(Polynomial n, Polynomial d, color c){
    super("rational", c);
    this.numerator = n;
    this.denominator = d;
    this.setSimplifiedFunction();
  }
  
  Rational(String numString, String denString, color col){
    //accepts numString and denString as polynomial strings in standard form
    super("rational", col);
    this.numerator = new Polynomial(numString, col);
    this.denominator = new Polynomial(denString, col);
    this.setSimplifiedFunction();
  }
  
  Rational(String isFactored, String numString, String denString, color col){
    //accepts numString and denString as polynomial strings in factored form - the parameter isFactored is to differnetiate this constructor from the one above
    super("rational", col);
    this.numerator = new Polynomial("factored", numString, col);
    this.denominator = new Polynomial("factored", denString, col);
    this.setSimplifiedFunction();
  }
  
  Rational(String inString, color col){
    //parameter isFactored is used to differentiate this constructor from the one above
    //accepts inString as a string of the form "(factor)(factor)(factor)(factor)/(factor)(factor)(factor)(factor)" (extra spaces permitted)
    super("rational", col);
    inString = removeSpaces(inString);
    int slashIndex = inString.indexOf('/');
    if(slashIndex == -1){
      println("Rational function requires  '/' character");
      raiseErrorWithoutAssert();
    }
    else if (slashIndex == inString.length()-1 ){
      println("No denominator detected");
      raiseErrorWithoutAssert();
    }
    if (count(inString, '(') != count(inString, ')')){
      println("Improper pairing of brackets");
      raiseErrorWithoutAssert();
    }
    String numString = inString.substring(0, slashIndex);
    String denString = inString.substring(slashIndex + 1, inString.length());
    this.numerator = new Polynomial("factored", numString, col);
    this.denominator = new Polynomial("factored", denString, col);
    if (this.denominator.getFunctionString().equals("0")){
      println("amongus");
      raiseErrorWithoutAssert();
    }
    this.setSimplifiedFunction();
  }
  
  Float f(float x){
    try{
      Float result = (numerator.f(x) / denominator.f(x));
      if (denominator.f(x) != 0){
        if (result != 0){
          return result;
        }
        else{
          return 0.0; //avoid return "-0.0"
        }
      }
      return null;
    }
    catch (Exception e){
      //in case we divide by 0
      return null;
    }
  }
  
  float[] xInts(){
    float[] xIntercepts = this.simplifiedNumerator.solveReals(); //we use the simplifiedNumerator since we don't want to return the value of holes
    return xIntercepts;
  }
  
  void plotOnPlane(CartesianPlane plane){
    //do the regular plotting
    stroke(this.col);
    
    float pixelStartX = plane.B.x;
    float pixelEndX = plane.C.x;
    Float unitX, unitY;
    PVector thisPoint;
    PVector prevPoint = null;
    
    while (pixelStartX <= pixelEndX){
      //println(pixelStartX);
      unitX = plane.getXUnit(pixelStartX);
      if (unitX != null){
        unitY = this.f(unitX);
        if (unitY != null){
          thisPoint = plane.getPixelPoint(unitX, unitY);
          if (thisPoint != null && prevPoint != null){
            line(prevPoint.x, prevPoint.y, thisPoint.x, thisPoint.y);
          }
          prevPoint = thisPoint;
        }
      }
      
      pixelStartX += 1;
      
    }
    
    
    //plot vertical asymptotes
    ArrayList<VA> verticalAsymptotes = new ArrayList<VA>();
    Polynomial[] denominatorFactors = this.simplifiedDenominator.factor();
    for (Polynomial p : denominatorFactors){
      float[] realSolutions = p.solveReals();
      for (float solution : realSolutions){
        //there is a VA at x = solution
        verticalAsymptotes.add(new VA(solution, this.col));
      }
    }
    
    for (VA va : verticalAsymptotes){
      va.plotOnPlane(plane);
    }
    
    //plot either oblique or horizontal asymptote
    if (this.denominator.degree > this.numerator.degree){
      //ha @ y = 0;
      HA ha = new HA(0, this.col);
      ha.plotOnPlane(plane);
    }
    else if (this.denominator.degree == this.numerator.degree){
      //ha @ y = a1/a2
      float a1 = this.numerator.terms[0].coefficient;
      float a2 = this.denominator.terms[0].coefficient;
      HA ha = new HA(a1/a2, this.col);
      ha.plotOnPlane(plane);
    }
    else if (this.numerator.degree == this.denominator.degree + 1){
      DivisionStatement result = this.numerator.divideBy(this.denominator); //loa at the quotient of this statement
      LOA loa = result.quotient.toLinear().toLOA();
      loa.col = this.col;
      loa.plotOnPlane(plane);
    }
    
    //plot any holes
    for (PVector hole : this.holes){
      fill(backgroundCol);
      PVector pixelPoint = plane.getPixelPoint(hole);
      if (pixelPoint != null){
        circle(pixelPoint.x, pixelPoint.y, holeSize);
      }
    }
  }
  
  void setSimplifiedFunction(){
    this.holes = new ArrayList<PVector>();
    ArrayList<Float> holeXs = new ArrayList<Float>();
    
    this.simplifiedNumerator = this.numerator;
    this.simplifiedDenominator = this.denominator;
    
    Polynomial[] simplifiedNumFactors = this.simplifiedNumerator.factor();
    Polynomial[] simplifiedDenFactors = this.simplifiedDenominator.factor();
    
    boolean foundCancellation = true; //set to true initially so we enter the loop
    
    while(foundCancellation){
      foundCancellation = false;
      simplifiedNumFactors = this.simplifiedNumerator.factor();
      simplifiedDenFactors = this.simplifiedDenominator.factor();
      
      int i = 0;
      while(i < simplifiedNumFactors.length){
      //for (int i = 0; i<simplifiedNumFactors.length; i++){
        Polynomial m = simplifiedNumFactors[i];
        
        //if m in simplifiedDenFactors aswell, we can cancel
        if (containsFactor(simplifiedDenFactors, m) && containsFactor(simplifiedNumFactors, m)){
          this.simplifiedNumerator = this.simplifiedNumerator.divideBy(m).quotient;
          this.simplifiedDenominator = this.simplifiedDenominator.divideBy(m).quotient;
          
          float[] thisFactorsHoles = m.solveReals();
          for (float thisFactorsHole : thisFactorsHoles){
            holeXs.add(thisFactorsHole);
          }
          
          foundCancellation = true;
          break;
        }
        i++;
      }
    }
    
    for (float holeX : holeXs){
      float holeY = this.simplifiedF(holeX);
      this.holes.add(new PVector(holeX, holeY));
    }
    
  }
  
  
  float simplifiedF(float x){
    return this.simplifiedNumerator.f(x) / this.simplifiedDenominator.f(x);
  }
  
  String getFunctionString(){
    String numString = this.numerator.getFunctionString();
    String denString = this.denominator.getFunctionString();
    return "(" + numString + ")/(" + denString + ")";
  }
  
  String getFactoredFunctionString(){
    String numString = this.numerator.getFactoredFunctionString();
    String denString = this.denominator.getFactoredFunctionString();
    return numString + "/" + denString;
  }
  
  String getSimplifiedFunctionString(){
    String numString = this.simplifiedNumerator.getFactoredFunctionString();
    String denString = this.simplifiedNumerator.getFactoredFunctionString();
    return numString + "/" + denString;
  }
}


class Reciprocal extends Rational{
  Reciprocal(Polynomial p, color col){
    super(new Linear(0, 1), p, col);
  }
  
  Reciprocal(Polynomial p){
    super(new Linear(0, 1), p, p.col);
  }
  
  Reciprocal(Rational r){
    super(r.denominator, r.numerator, r.col);
  }
  
  Reciprocal(Rational r, color col){
    super(r.denominator, r.numerator, col);
  }
}
