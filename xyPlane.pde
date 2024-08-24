int pixelTickSize = 40; //pixels
int fontSize = 14; //pixels
int xLabelMargin = 15;
int yLabelMargin = 5; //pixels


class CartesianPlane{
  PVector pos; //coords of the origin
  float xAxisLength, yAxisLength; //in pixels
  float xMax, yMax; //in units
  float xScale, yScale; //in pixels per unit
  float xTickSize, yTickSize;
  PVector A, B, C, D;
  
  
  //Constructor
  CartesianPlane(PVector p, float lw, float xm, float ym){
    this.pos = p;
    this.xAxisLength = lw;
    this.yAxisLength = lw; //pixels -- the length from the origin to A
    
    this.xMax = xm;
    this.yMax = ym; //units
    
    this.xScale = (this.xAxisLength)/this.xMax; 
    this.yScale = (this.yAxisLength)/this.yMax; // pixels per unit
    
    this.xTickSize = (1.0/this.xScale * pixelTickSize);
    this.yTickSize = (1.0/this.yScale * pixelTickSize); //units
    
    
    /***  A
          |
          |
          |
  B-------O-------C
          |
          |
          |
          D
    ***/
    
    //O = this.pos;
    //OA = OD =this.xAxisLength in terms of pixels
    //OB = OC =this.yAxisLength in terms of pixels
    
    this.B = new PVector(this.pos.x - this.xAxisLength, this.pos.y);
    this.C = new PVector(this.pos.x + this.xAxisLength, this.pos.y);
    this.A = new PVector(this.pos.x, this.pos.y - this.yAxisLength);
    this.D = new PVector(this.pos.x, this.pos.y + this.yAxisLength);
  }
  
  
  //methods
  void drawPlane(){
    PVector O = this.pos;

    //draw the axis
    stroke(255);
    fill(255);
    strokeWeight(2);
    line(this.B.x, this.B.y, this.C.x, this.C.y);
    line(this.A.x, this.A.y, this.D.x, this.D.y);
    
    //label the x axis
    textSize(fontSize);
    PVector xPixels = this.B.copy();
    float xUnits = -this.xMax;
    while(xUnits <= this.xMax){
      circle(xPixels.x, xPixels.y, 2);
      text(nf(roundToSigFigs(xUnits, 2), 0, 0), xPixels.x - xLabelMargin/2.5, xPixels.y + xLabelMargin);
      xPixels.x += pixelTickSize;
      xUnits += this.xTickSize;
    }
    
    //label the y axis
    PVector yPixels = this.D.copy();
    float yUnits = -this.yMax;
    while(yUnits <= this.yMax){
      circle(yPixels.x, yPixels.y, 2);
    
      if (yUnits != 0){
        text(nf(roundToSigFigs(yUnits, 2), 0, 0), yPixels.x + yLabelMargin, yPixels.y + xLabelMargin/3.0);
      }
      yPixels.y -= pixelTickSize;
      yUnits += this.yTickSize;
      
    }
  }
  
  
  PVector getPixelPoint(PVector unitPoint){
    return this.getPixelPoint(unitPoint.x, unitPoint.y);
  }
  PVector getPixelPoint(float unitX, float unitY){
    if (abs(unitX) > this.xMax || abs(unitY) > this.yMax){
      return null;
    }
    //compute pixel coords relative to origin
    float pixelX = unitX/this.xMax * this.xAxisLength;
    float pixelY = -unitY/this.yMax * this.yAxisLength;
    PVector pixelPoint = new PVector(pixelX, pixelY);
    return PVector.add(this.pos, pixelPoint);
  }
  
  Float getXUnit(float pixelX){
    pixelX -= this.pos.x;
    if (abs(pixelX) > this.xAxisLength){
      return null;
    }
    return pixelX/this.xAxisLength * this.xMax;
  }
  
  Float getYUnit(float pixelY){
    pixelY -= this.pos.y;
    pixelY *= -1;
    if (abs(pixelY) > this.yAxisLength){
      return null;
    }
    return pixelY/this.yAxisLength * this.yMax;
  }
  
  PVector getUnitPoint(float pixelX, float pixelY){
    float unitX = getXUnit(pixelX);
    float unitY = getYUnit(pixelY);
    return new PVector(unitX, unitY);
  }
  PVector getUnitPoint(PVector pixelPoint){
    return this.getUnitPoint(pixelPoint.x, pixelPoint.y);
  }
  
  
  void scaleX(float amount){
    this.xMax += amount/this.xScale;
    this.xScale = (this.xAxisLength)/this.xMax; 
    this.xTickSize = (1.0/this.xScale * pixelTickSize);
  }
  void scaleY(float amount){
    this.yMax += amount/this.yScale;
    this.yScale = (this.yAxisLength)/this.yMax; // pixels per unit
    this.yTickSize = (1.0/this.yScale * pixelTickSize); //units
    
  }
  void scalePlane(float amount){
    this.scaleX(amount);
    this.scaleY(amount);
  }
  
  
  boolean isOnPlane(PVector p){
    float minX, maxX, minY, maxY;
    minX = this.pos.x - this.xAxisLength;
    maxX = this.pos.x + this.xAxisLength;
    minY = this.pos.y - this.yAxisLength;
    maxY = this.pos.y + this.yAxisLength;
    //return true;
    return (minX < p.x && p.x < maxX) && (minY < p.y && p.y < maxY) ;
  }
  
  void setPosTo(PVector newPos){
    this.pos = newPos;
    this.B = new PVector(this.pos.x - this.xAxisLength, this.pos.y);
    this.C = new PVector(this.pos.x + this.xAxisLength, this.pos.y);
    this.A = new PVector(this.pos.x, this.pos.y - this.yAxisLength);
    this.D = new PVector(this.pos.x, this.pos.y + this.yAxisLength);
  }
}
