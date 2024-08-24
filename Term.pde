class PolynomialTerm{
  float coefficient; //any real number
  int degree; // a non-negative integer
   
  //creates a term object given the coefficient and power
  PolynomialTerm(float c, int d){
    //cx^d
    this.coefficient = c;
    raiseErrorWithoutAssert( d%1==0 && d >= 0 );
    this.degree = d;
  }
  
  //creates a term object given a string representing it (e.g. "-5x^4")
  PolynomialTerm(String inString){
    inString = removeSpaces(inString);
    //check if there is an 'x' in the string
    int xIndex = inString.indexOf("x");
    if (xIndex != -1){
      String coefficientPart = inString.substring(0, xIndex);
      String afterXPart = inString.substring(xIndex+1 , inString.length());
      
      //convert the coefficient from string to float if possible
      Float tryToMakeCoefficient = getCoefficient(coefficientPart);
      if(xIndex == 0){
        this.coefficient = 1;
      }
      else if (tryToMakeCoefficient != null){
        //the coefficient part of the string is valid. 
        this.coefficient = tryToMakeCoefficient;
      }
      else{
        println("could not compute coefficient part");
        raiseErrorWithoutAssert();
        return;
      }
      
      //get the degree now
      if (this.coefficient == 0){
        //this is the 0 term. It's degree should be o
        this.degree = 0;
        return;
      }
      else if (afterXPart.length() == 0){
        // of the form "ax"
        // no need to compute anything else - we can set the degree to 1 and return
        this.degree = 1;
        return;
      }
      
      else{
        // of the form "ax^n"
        if (afterXPart.charAt(0) == '^'){
          //do stuff
          String  degreePart = afterXPart.substring(1, afterXPart.length());
          Float tryDegree = getCoefficient(degreePart);
          if (tryDegree == null){
            println("could not compute power part");
            raiseErrorWithoutAssert();
            return;
          }
          if (tryDegree < 0){
            println("power must be >= 0");
            raiseErrorWithoutAssert();
            return;
          }
          if (tryDegree %1 != 0){
            println("power must be an integer");
            raiseErrorWithoutAssert();
            return;
          }
          //we are good to set the degree now
          this.degree = int(tryDegree);
          return;
        }
        
        
        else{
          println("please add the '^' symbol before the power");
          raiseErrorWithoutAssert();
          return;
        }
      }
    }
    //if not, this is a constant term
    else{ 
      //inString is uof the form "a"
      Float tryToMakeCoefficient = getCoefficient(inString);
      if (tryToMakeCoefficient != null){
        //the coefficient part of the string is valid. 
        this.coefficient = tryToMakeCoefficient;
        this.degree = 0;
        return;
      }
      else{
        println("could not compute coefficient part");
        raiseErrorWithoutAssert();
        return;
      }
    }
  }
  
  float getValue(float x){
    return this.coefficient * pow(x, this.degree);
  }
  
  PolynomialTerm multWithTerm(PolynomialTerm other){
    return new PolynomialTerm(this.coefficient * other.coefficient, this.degree + other.degree);
  }
  
  PolynomialTerm divideByTerm(PolynomialTerm other){
    raiseErrorWithoutAssert(this.degree - other.degree >= 0);
    return new PolynomialTerm(this.coefficient / other.coefficient, this.degree - other.degree);
  }
  
  PolynomialTerm addTerm(PolynomialTerm other){
    raiseErrorWithoutAssert(this.degree == other.degree);
    return new PolynomialTerm(this.coefficient + other.coefficient, this.degree);
  }
  
  PolynomialTerm subtractTerm(PolynomialTerm other){
    raiseErrorWithoutAssert( this.degree == other.degree );
    return new PolynomialTerm(this.coefficient - other.coefficient, this.degree);
  }
  
  PolynomialTerm multByConstant(float c){
    return new PolynomialTerm(this.coefficient * c, this.degree);
  }
  
  String getTermString(){
    return this.getTermString(false, false);
  }
  
  String getTermString(boolean showUselessExponents, boolean showUselessCoefficients){
    String partWithoutCoefficient = this.getTermWithoutCoefficient(showUselessExponents);
    String partWithoutX = this.getCoefficientString(showUselessCoefficients);
    
    return partWithoutX + partWithoutCoefficient;
  }
  
  String getTermWithoutCoefficient(boolean showUselessExponents){
    if (!showUselessExponents && this.degree == 1){
      return "x";
    }
    else if (!showUselessExponents && this.degree == 0){
      return "";
    }
    
    return "x^" + this.degree;
  }
  
  String getCoefficientString(boolean showUselessCoefficients){
    if (!showUselessCoefficients && this.coefficient == 1){
      if (this.degree == 0){
        return "1";
      }
      return "";
    }else if (!showUselessCoefficients && this.coefficient == -1){
      if (this.degree == 0){
        return "-1";
      }
      return "-";
    }else if (!showUselessCoefficients && this.coefficient == 0){
      return "";
    }
    
    return nf(this.coefficient);
  }
}
