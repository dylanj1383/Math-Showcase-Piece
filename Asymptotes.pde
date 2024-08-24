class HA extends Constant{
  //horizontal asymptote
  HA(float c){
    super(c);
  }
  HA(float c, color col){
    super(c, col);
  }
  
  void plotOnPlane(CartesianPlane plane){
    plotOnPlane(plane, dottedLineSpacing, true);
  }
}

class LOA extends Linear{
  LOA(float m, float b){
    super(m, b);
  }
  LOA(float m, float b, color c){
    super(m, b, c);
  }
  
  void plotOnPlane(CartesianPlane plane){
    //calculate the right resolution so that the line itself appears to have the right dash-length regardless of slope
    
    /***
    m = slope
    v = dash-length of dotted line
    k = half of resolution for dotted line
    |\
    | \
 km |  \ v
    |   \
    |____\
       k
    
    slope = deltay/deltax = km/k = m 
    
    v^2 = (km)^2 + k^2 
    v^2 = k^2m^2 + k^2
    v^2 = (1+m^2)k^2
    v^2/(1+m^2) = l^2
    k = sqrt(v^2/(1+m^2))
    ***/
    
    int v = dottedLineSpacing;
    
    
    PVector p1 = plane.getPixelPoint(0, 0);
    PVector p2 = plane.getPixelPoint(m, 1);
    m = (p2.y - p1.y)/(p2.x - p1.x);
    
    int spacing = round(sqrt(float(v*v)/(1+m*m))); //multiply by 2 since the spacing gives only the half-distance
    spacing = max(1, spacing);
    this.plotOnPlane(plane, spacing, true);
  }
}

class VA{
  float x;
  color col;
  //treat this like the inverse of a horizontal line
  VA(float val){
    this.x = val;
    this.col = color(255);
  }
  VA(float val, color c){
    this.x = val;
    this.col = c;
  }
  
  float f(float y){
    return x;
  }
  
  //clone of the method from the Function class, but swap x and y
  void plotOnPlane(CartesianPlane plane){
    stroke(this.col);
    int resolution = 10;
    
    float pixelStartY = plane.A.y;
    float pixelEndY = plane.D.y;
    Float unitX, unitY;
    PVector thisPoint;
    PVector prevPoint = null;
    
    boolean showSegment = true;
    
    while (pixelStartY <= pixelEndY){
      //println(pixelStartX);
      unitY = plane.getYUnit(pixelStartY);
      if (unitY != null){
        unitX = this.f(unitY);
        thisPoint = plane.getPixelPoint(unitX, unitY);
        if (thisPoint != null && prevPoint != null){
          if (showSegment){
            line(prevPoint.x, prevPoint.y, thisPoint.x, thisPoint.y);
          }
          showSegment = !showSegment;
        }
        prevPoint = thisPoint;
        
      }
      
      pixelStartY += resolution;
      
    }
  }
}
