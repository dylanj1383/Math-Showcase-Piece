//parameters
int dottedLineSpacing = 10;
float planeSize = 200;
float startingAxisMax = 10;
float holeSize = 9;

//colors
color green = color(0, 255, 0);
color white = color(255);
color white1 = color(225);
color grey2 = color(150);
color black = color(0);


color backgroundCol = black;
color primaryFunctionCol = green;
color secondaryFunctionCol = color(7, 150, 245);

//mathematical constants
float e = 2.71828182845904;


//Global Variables
CartesianPlane plane;
Menu menu;
float menuWidth;
PVector screenCenter;


void setup(){
  size(1000, 600);
  screenCenter = new PVector(width/2.0, height/2.0);
  plane = new CartesianPlane(PVector.add(screenCenter, new PVector(width/4, 0)), planeSize, startingAxisMax, startingAxisMax);
  
  String[] options = {"Polynomial", "Rational", "Exponential", "Logarithmic"};
  Dropdown d = new Dropdown(new PVector(width/9.0, 100), grey2, white1, black, options, "Polynomial");
  TextInput t = new TextInput(new PVector(85, 320), "Enter function here");
  menuWidth = width/2.0;
  menu = new Menu(menuWidth, d, t);
}

void draw(){
  background(backgroundCol);
  plane.drawPlane();
  menu.drawMenu();
}
