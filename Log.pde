class Logarithmic extends Function{
  float a, k; //vertical and horizontal stretch coefficients 
  float b; //base
  float q, p; //vertical and horizontal translation values
  
  //y = a*log_b(k(x-p)) + q
  
  Logarithmic(float a, float b, float k, float p, float q, color col){
    super("logarithmic", col);
    if (b == 1 || b<=0){
      println("invalid base for the logarithm");
      raiseErrorWithoutAssert();
    }
    this.a = a;
    this.k = k;
    this.b = b;
    this.q = q;
    this.p = p;
  }
  
  
  Logarithmic(String inString, color col){
    super("logarithmic", col);
    inString = removeSpaces(inString);
    String aPart;
    String notAPart;
    // a*log_b(k(x-p)) + q
    // alog_b(k(x-p)) + q
    
    if (inString.indexOf("log") == -1 && inString.indexOf("ln") == -1){
      println("function must contain 'log' or 'ln'");
      raiseErrorWithoutAssert();
    }
    
    //contains * --> slice before and after the *
    //a*log_b(k(x-p)) + q
    if (inString.indexOf('*') != -1){
      aPart = inString.substring(0, inString.indexOf('*'));
      if (aPart.equals("")){
        aPart = "1";
      }
      notAPart = inString.substring(inString.indexOf('*')+1, inString.length());
    }
    
    //doesnt contain * --> slice before/after the l from "log" or "ln"
    //alog_b(k(x-p)) + q
    else {
      int lIndex = inString.indexOf('l');
      aPart = inString.substring(0, lIndex);
      notAPart = inString.substring(lIndex, inString.length());
    }
    
    if (aPart.equals("")){
      aPart = "1";
    }
    else if (aPart.equals("-")){
      aPart = "-1";
    }
   
    
    //log_b(k(x-p)) + q 
    //log(k(x-p)) + q
    //ln(k(x-p)) + q
    
    String bPart;
    String notBPart;
    if(notAPart.indexOf('_') != -1){
      if (notAPart.indexOf("log_") == -1){
        println("Invalid base or argument to log. Please specify your base with '_'.");
        raiseErrorWithoutAssert();
      }
      //log_b(k(x-p)) + q 
      int underScoreIndex = notAPart.indexOf('_');
      int firstBrackIndex = notAPart.indexOf('(');
      bPart = notAPart.substring(underScoreIndex+1, firstBrackIndex);
      notBPart = notAPart.substring(firstBrackIndex, notAPart.length());
    }
    
    else{
      //log(k(x-p)) + q
      //or ln(k(x-p)) + q
      
      if (notAPart.indexOf('n') != -1){
        //ln(k(x-p)) + q
        if (notAPart.indexOf("ln(") == -1){
          println("Invalid argument to ln. Ensure your argument is surrounded by brackets");
          raiseErrorWithoutAssert();
        }
        bPart = "e";
      }
      else{
        //log(k(x-p)) + q
        if (notAPart.indexOf("log(") == -1){
          println("Invalid argument to log. Ensure your argument is surrounded by brackets");
          raiseErrorWithoutAssert();
        }
        bPart = "10";
      }
      int firstBrackIndex = notAPart.indexOf('(');
      notBPart = notAPart.substring(firstBrackIndex, notAPart.length());
    }
    
    
    //(k(x-p)) + q
    //    {notBPart      }
    //3^   (-2x)      + 4    (2)
    //3^   (-3(x-1))  + 4    (3)
    //3^   (x-1)     - 8     (4)
    String argumentPart;
    String qPart;
 
    //case 2, 3, or 4
    String noOpeningBracket = notBPart.substring(1, notBPart.length());
    if ( noOpeningBracket.indexOf('(') == -1 ){

      //case 2 or 4
      
      //qPart is from the ) to the end
      int cbIndex = notBPart.indexOf(')');
      qPart = notBPart.substring(cbIndex+1, notBPart.length());
      argumentPart = notBPart.substring(1, cbIndex);
      
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

      
      Polynomial argumentPartPoly = new Polynomial("factored", "(" + part1 + ")(" + part2 + ")", col);

      argumentPart = argumentPartPoly.getFunctionString();
    }
    
    //we have now extracted the strings of aPart, bPart, exponentPart (k(x-4)), and qPart
    Float aVal = getCoefficient(aPart);
    Float bVal = getCoefficient(bPart); //the base "e" is also handled here
    Float qVal = getCoefficient(qPart);
    
    Polynomial argumentPartPolyNomial = new Polynomial(argumentPart, col);
    Linear l = argumentPartPolyNomial.toLinear(); //mx + b = m(x + b/m) ; (remove red flags)  k(x-p)
    float kVal = l.m;
    float pVal = -l.b/l.m;
    
    if (aVal == null || bVal == null || qVal == null){
      println("unable to extract function");
      raiseErrorWithoutAssert();
    }
    else{
      if (bVal == 1 || bVal<=0){
        println("invalid base for the logarithm");
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
    float argument = this.k*(x-this.p);
    //a*log_b(k(x-p)) + q
    //
    float logBofArg = log(argument) / log(this.b);
    Float answer = this.a*logBofArg + this.q;
    if (!answer.isInfinite()){
      return this.a*logBofArg + this.q;
    }
    return null;
  }
  
  void plotOnPlane(CartesianPlane plane){
    stroke(this.col);
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
    
    //get the vertical asymptote (at x = this.p)
    VA va = new VA(this.p, this.col);
    va.plotOnPlane(plane);
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
    
    String logPart;
    if (this.b == 10){
      logPart = "log";
    }
    else if (this.b == e){
      logPart = "ln";
    }
    else{
      logPart = "log_" + nf(this.b);
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
        argumentPart = "x+" + nf(negP);
      }
      else{
        //p > 0 (e.g. p = 2)
        //x-p --> x-2
        argumentPart = "x-" + nf(this.p);
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
        innerPart = "x+" + nf(negP);
      }
      else{
        //p > 0 (e.g. p = 2)
        //x-p --> x-2
        innerPart = "x-" + nf(this.p);
      }
      
      
      if (this.p == 0){
        //just kPart, no brackets and no p
        //argument is something like -3x
        argumentPart = kPart + innerPart;
      }
      else{
        //argument is somethingl ike -3(x+2)
        //we need the kPart and we need to get the pPart
        argumentPart = kPart + "(" + innerPart + ")";
      }
    }
    
    String qPart;
    if (this.q == 0){
      qPart = "";
    }
    else if (this.q < 0){
      qPart = nf(this.q);
    }
    else{
      qPart = "+" + nf(this.q);
    }
    
    
    //return "" + this.a + "," + this.b + "," + this.k + "," + this.p + "," + this.q;
    return aPart + logPart + "(" + argumentPart + ")" + qPart;
  }
  
  Exponential getInverse(){
    return this.getInverse(this.col);
  }
  Exponential getInverse(color c){
    //y = a*log_b(k(x-p)) + q
    //x = 1/k  *  b^ ( 1/a (y-q) ) + p
    //     a      b     k     p      q
    return new Exponential(1/this.k, this.b, 1/this.a, this.q, this.p, c);
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
    //0 = alog_b(k(x-p))+q
    //x = [b^(-q/a)]/k + p
    float answer = pow(this.b, -this.q/this.a) / this.k + this.p;
    Float answer2 = pow(this.b, -this.q/this.a) / this.k + this.p;
    if (answer == answer && !answer2.isInfinite()){
      return answer;
    }
    return null;
  }
}
