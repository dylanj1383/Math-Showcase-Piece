class Exponential extends Function{
  //y = a*b^(k(x-p)) + q
  float a, k; //vertical and horizontal stretch coefficients 
  float b; //base
  float q, p; //vertical and horizontal translation values
  Exponential(float a, float b, float k, float p, float q, color col){
    super("exponential", col);
    if (b == 1 || b<=0){
      println("invalid base for the exponential");
      raiseErrorWithoutAssert();
    }
    this.a = a;
    this.k = k;
    this.b = b;
    this.q = q;
    this.p = p;
  }
  
  Exponential(String inString, color col){
    //things it doesnt (yet) handle:
      // -2^(x+4) + 5  because there is no *, it presumes there is no starting coefficient
      //-1*2^((x+4)) + 5 because it cannot handle unnecessary nested brackets
    super("exponential", col);
    inString = removeSpaces(inString);
    String aPart;
    String notAPart;
    // a*b^(k(x+p)) + q
    //contains a value
    if (inString.indexOf('*') != -1){
      aPart = inString.substring(0, inString.indexOf('*'));
      if (aPart.equals("")){
        aPart = "1";
      }
      notAPart = inString.substring(inString.indexOf('*')+1, inString.length());
    }
    //contains no a value
    else{
      if(inString.charAt(0) == '-'){
        aPart = "-1";
        notAPart = inString.substring(1, inString.length());
      }
      else{
        aPart = "1";
        notAPart = inString;
      }
    }
    
    String bPart = "";
    String notBPart = "";
    //b^(k(x+p)) + q
    //it must contain a b value
    if (notAPart.indexOf('^') == -1){
      raiseErrorWithoutAssert();
    }
    else{
      bPart = notAPart.substring(0, notAPart.indexOf('^'));
      notBPart = notAPart.substring(notAPart.indexOf('^')+1, notAPart.length());
    }
    
    
    //(k(x-p)) + q
    //    {notBPart      }
    //3^   -x         + 4    (1)
    //3^   (-2x)      + 4    (2)
    //3^   (-3(x-1))  + 4    (3)
    //3^   (x-1)     - 8     (4)
    String exponentPart;
    String qPart;
    
    if (notBPart.charAt(0) != '('){

      //case 1: 3^-x + 4
      //-x is exponentPart
      //+4 is qPart
      
      int xIndex = notBPart.indexOf('x');
      exponentPart = notBPart.substring(0, xIndex+1);
      qPart = notBPart.substring(xIndex+1, notBPart.length());
    }
    else{
      //case 2, 3, or 4
      String noOpeningBracket = notBPart.substring(1, notBPart.length());
      if ( noOpeningBracket.indexOf('(') == -1 ){

        //case 2 or 4
        
        //qPart is from the ) to the end
        int cbIndex = notBPart.indexOf(')');
        qPart = notBPart.substring(cbIndex+1, notBPart.length());
        exponentPart = notBPart.substring(1, cbIndex);
        
      }
      else{
        //case 3
        // -3(x-1))  + 4 is in noOpeningBracket
        int ob2Index = noOpeningBracket.indexOf('('); //opening bracket #2 index
        String part1 = noOpeningBracket.substring(0, ob2Index); //contains "-3"

        int cb1Index = noOpeningBracket.indexOf(')'); //closing bracket #1 index
        String part2 = noOpeningBracket.substring(ob2Index+1, cb1Index); //contains "x-1"

        
        String justLastClosingBracket = noOpeningBracket.substring(cb1Index+1, noOpeningBracket.length()); //contains ")+4"
        qPart = justLastClosingBracket.substring(1, justLastClosingBracket.length()); //contains "+4"

        
        Polynomial exponentPartPoly = new Polynomial("factored", "(" + part1 + ")(" + part2 + ")", col);

        exponentPart = exponentPartPoly.getFunctionString();
      }
    }
    
    //we have now extracted the strings of aPart, bPart, exponentPart (k(x-4)), and qPart
    Float aVal = getCoefficient(aPart);
    Float bVal = getCoefficient(bPart); //the base "e" is also handled here
    Float qVal = getCoefficient(qPart);
    
    Polynomial exponentPartPolyNomial = new Polynomial(exponentPart, col);
    Linear l = exponentPartPolyNomial.toLinear(); //mx + b = m(x + b/m) ; (remove red flags)  k(x-p)
    float kVal = l.m;
    float pVal = -l.b/l.m;
    
    if (aVal == null || bVal == null || qVal == null){
      println("unable to extract function");
      raiseErrorWithoutAssert();
    }
    else{
      if (bVal == 1 || bVal<=0){
        println("invalid base for the exponential");
        raiseErrorWithoutAssert();
      }
      this.a = aVal;
      this.k = kVal;
      this.b = bVal;
      this.q = qVal;
      this.p = pVal;
    }
  }
  
  Float f(float x){
    float exponent = this.k*(x-this.p);
    return this.a*pow(this.b, exponent) + this.q;
  }
  

  String getFunctionString(){
    String aPart;
    if (this.a == 1){
      aPart = "";
    }
    else if (this.a == -1){
      aPart = "-";
    }
    else{
      aPart = nf(this.a)  + "*";
    }
    
    String bPart;
    if (this.b == e){
      bPart = "e";
    }
    else{
      bPart = nf(this.b);
    }
    
    
    
    String argumentPart;
    if ( this.k == 1){
      //no k part 
      //x-p
      //or 
      //x
      
      if (this.p == 0){
        argumentPart = "x";
      }
      else if (p < 0){
        //e.g. p = -2
        //x-p --> x+2
        float negP = this.p * -1; //"2"
        argumentPart = "(x+" + nf(negP) + ")";
      }
      else{
        //p > 0 (e.g. p = 2)
        //x-p --> x-2
        argumentPart = "(x-" + nf(this.p) + ")";
      }
    }
    
    else{
      //we will need brackets around the (x-p), unless p is 0
      //regardless, there is a kpart
      String kPart;
      if (this.k == -1){
        kPart = "-";
      }
      else{
        kPart = nf(this.k);
      }
      
      String innerPart;
      if (this.p == 0){
        innerPart = "x";
      }
      else if (p < 0){
        //e.g. p = -2
        //x-p --> x+2
        float negP = this.p * -1; //"2"
        innerPart = "x+" + nf(negP) ;
      }
      else{
        //p > 0 (e.g. p = 2)
        //x-p --> x-2
        innerPart = "x-" + nf(this.p);
      }
      
      
      if (this.p == 0){
        //just kPart, no brackets and no p
        //argument is something like -3x
        argumentPart = "(" + kPart + innerPart + ")";
      }
      else{
        //argument is somethingl ike -3(x+2)
        //we need the kPart and we need to get the pPart
        argumentPart = "[" + kPart + "(" + innerPart + ")]" ;
      }
    }
    
    String qPart;
    if (this.q == 0){
      qPart = "";
    }
    else if (this.q > 0){
      qPart = "+" + nf(this.q);
    }
    else{
      qPart = nf(this.q);
    }
    return aPart + bPart + "^" + argumentPart + qPart;
  }
  
  void plotOnPlane(CartesianPlane plane){
    stroke(this.col);
    
    //plot regularly from function
    int resolution = 1;
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
      pixelStartX += resolution;
    }
    
    
    //plot the HA
    HA ha = new HA(q, this.col);
    ha.plotOnPlane(plane);
  }
  
  float[] xInts(){
    Float xIntercept = this.solve();
    if(xIntercept != null){
      float[] xIntercepts = new float[1];
      xIntercepts[0] = xIntercept;
      return xIntercepts;
    }
    else{
      return new float[0];
    }
  }
  
  Float solve(){
    float answer = ( log(-this.q/this.a) / log(this.b) )/this.k + this.p;
    Float answer2 = ( log(-this.q/this.a) / log(this.b) )/this.k + this.p;
    if (answer == answer && ! answer2.isInfinite()){ //NaN  != Nan
      return answer;
    }
    return null;
  }
  
  Logarithmic getInverse(){
    return this.getInverse(this.col);
  }
  Logarithmic getInverse(color c){
    //y = a*b^(k(x-p))+q
    //x = 1/k  *  log_b( 1/a (y-q) ) + p  (logarithmic form)
    //    a           b   k     p     q
    return new Logarithmic(1/this.k, this.b, 1/this.a, this.q, this.p, c);
  }
}
