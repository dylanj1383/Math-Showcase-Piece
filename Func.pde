class Function{
  String type; //polynomial, exponential, logarithmic, rational
  color col;
  Function (String type){
    this.type = type;
    this.col = color(255);
  }
  Function(String type, color c){
    this.type = type;
    this.col = c;
  }
  
  Float f(float x){
    return x; //this function will be overwritten for its inherited classes
  }
  
  Float yInt(){
    return this.f(0); //sometimes it can be null, so we use Float instead of float
  }
  
  float[] xInts(){
    float[] xIntercepts = {}; //use float since if an xInt doesnt exist, we just return the empty arary
    return xIntercepts; //will be overwritten for its inherited classes
  }
  
  Polynomial[] factor(){
    Polynomial[] factors = new Polynomial[0];
    return factors;
  }
  
  String getFunctionString(){
    return ""; //should be overwritten for its inherited classes
  }
  
  String getFactoredFunctionString(){
    return ""; //should be overwritten only for the polynomial or rational classes
  }
  
  void plotOnPlane(CartesianPlane plane){
    plotOnPlane(plane, 1, false);
  }
  
  
  void plotOnPlane(CartesianPlane plane, int resolution, boolean isDotted){
    stroke(this.col);
    
    float pixelStartX = plane.B.x;
    float pixelEndX = plane.C.x;
    Float unitX, unitY;
    PVector thisPoint;
    PVector prevPoint = null;
    
    boolean showSegment = true;
    
    while (pixelStartX <= pixelEndX){
      //println(pixelStartX);
      unitX = plane.getXUnit(pixelStartX);
      if (unitX != null){
        unitY = this.f(unitX);
        if (unitY != null){
          thisPoint = plane.getPixelPoint(unitX, unitY);
          if (thisPoint != null && prevPoint != null){
            if (!(isDotted && !showSegment)){
              line(prevPoint.x, prevPoint.y, thisPoint.x, thisPoint.y);
            }
            showSegment = !showSegment;
          }
          prevPoint = thisPoint;
        }
      }
      
      pixelStartX += resolution;
      
    }
  }
  
  String getYIntString(){
    Float yInt = this.yInt();
    if (yInt != null){
      return "Y-intercept: " + yInt;
    }
    else{
      return "No y-intercept";
    }
  }
  
  String getXIntString(){
    float[] xInts = this.xInts();
    
    if (xInts.length > 0){
      String xIntsString = "X-intercept(s): ";
      for (float xInt : xInts){
        xIntsString = xIntsString + xInt + ", ";
      }
      return xIntsString.substring(0, xIntsString.length() - 2);
    }
    else{
      return "No x-intercepts";
    }
  }
}
