//INPUT HANDLERS
void mousePressed(){
  menu.mousePressed();
}

void mouseClicked(){
  println(mouseX,mouseY);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  //positive e = scrolled down
  //negative e = scrolled up
  plane.scalePlane(e); //zoom into the plane
}

void keyPressed(){
  if (key == 'r'){ 
    //reset scrolling
    plane = new CartesianPlane(PVector.add(screenCenter, new PVector(width/4, 0)), planeSize, startingAxisMax, startingAxisMax);
  }
  
  menu.keyPressed();
}


//HELPER FUNCTIONS
int gcd(int a, int b){
  //returns the gcd of two integers using euclids algorithm
  //returns only the positive gcd if negative ones exist
  assert a!= 0 && b!=0;
  a = abs(a);
  b = abs(b);
  
  int min = min(a, b);
  int max = max(a, b);
  int rem = max%min;
  
  while (rem!=0){
    max = min;
    min = rem;
    rem = max%min;
  }
  return min;
}

int gcd (Polynomial p){
  //returns the gcd of all the coefficients of p
  ArrayList<Float> nums = new ArrayList<Float>();
  for (PolynomialTerm t : p.terms){
    if (t.coefficient != 0){
      nums.add(t.coefficient);
    }
  }
  return gcd(nums);
}

int gcd (ArrayList<Float> nums){
  //take in a ArrayList of Floats because ints/floats are not supported for arrayList
  //still, every value in nums must be an integer (but its datatype is float)
  
  //the function above, gcd, returns the gcd of two numbers. This can be denoted as gcd2() [although it's called gcd]
  //this current function, gcd, returns the gcd of a list of numbers. This can be denoted as gcdn() [although it's also called gcd]
  //we will use recursion, making the assumption that gcdn() is already fully functional
  //thus, gcdn can return gcd2(last_element_in_list, gcd(rest_of_list))
  //the base case is if there is only 2 numbers in the list, in which case we can return gcd2(num1, num2)
 
  int n = nums.size();
  
  //base case
  if (n==2){
    return gcd(int(nums.get(0)), int(nums.get(1)));
  }
  else if (n < 2) {
    return int(nums.get(0));
  }

  int num1 = int(nums.get(n-1)); //get the last element of the list
  nums.remove(n-1); //remove that element from the list
  return gcd(num1, gcd(nums));
}

float[] getFactors(float num){
  //returns an arrayList of the factors of some |num|

  int n = int(abs(num));
  ArrayList<Float> factors = new ArrayList<Float>();
  
  if (n == 0){
    factors.add(0.0);
  }
  else{
    for (int i = 1; i <= n; i++){
      if (n%i == 0){
        factors.add(float(i));
      }
    }
  }
  
  float[] factorsArray = new float[factors.size()];
  
  for (int i = 0; i < factors.size(); i++){
    factorsArray[i] = factors.get(i);
  }
  
  return factorsArray;
}


Float getCoefficient(String inString){
  if (inString.equals("")){
    return 0.0;
  }
  else if (inString.equals("+")){
    return 1.0;
  }
  else if (inString.equals("-")){
    return -1.0;
  }
  else if (inString.equals("e")){
    return e;
  }
  float c = float(inString);
    //make sure c is non Nan (NaN =/= NaN)
    if (c == c){
      return c;
    }
    else{
      return null;
    }
}


String removeSpaces(String inString){
  String outString = "";
  for (int i = 0; i<inString.length(); i++){
    if (inString.charAt(i) != ' '){
      outString = outString + inString.charAt(i);
    }
  }
  
  return outString;
}


void raiseErrorWithoutAssert(){
  int[] thingy = {1, 1};
  thingy[3]=4;
}

void raiseErrorWithoutAssert(boolean condition){
  if (!condition){
    int[] thingy = {1, 1};
    thingy[3]=4;
  }
}
boolean containsFactor(Polynomial[] factors, Polynomial f){
  for (Polynomial checkFactor : factors){
    if (checkFactor.equals(f)){
      return true;
    }
  }
  return false;
}
int findMaxDegree(PolynomialTerm[] terms){
  int maxDegree = 0;
  for (PolynomialTerm t : terms){
    maxDegree = max(t.degree, maxDegree);
  }
  return maxDegree;
}

PolynomialTerm[] addTermArrays(PolynomialTerm[] t1, PolynomialTerm[] t2){
  PolynomialTerm[] output = new PolynomialTerm[t1.length + t2.length];
  
  for (int i = 0; i < t1.length; i++){
    output[i] = t1[i];
  }
  for (int i = 0; i < t2.length; i++){
    output[i+t1.length] = t2[i];
  }
  
  return output;
}



int maxNumDecimalPlaces(PolynomialTerm[] terms){
  int maxDps = 0;
  for (PolynomialTerm p : terms){
    //if (p.coefficient % 1 != 0){
    //  return false;
    //}
    float thisVal = p.coefficient;
    int numDps = 0;
    while (thisVal % 1 != 0){
      thisVal *= 10;
      numDps ++;
    }
    maxDps = max(maxDps, numDps);
  }
  return maxDps;
}

float roundToSigFigs(float f, int n) {
  if (f>99){
    return round(f);
  }
  String fStr = String.format("%.0" + n + "G", f);
  return float(fStr);
}

boolean solutionAlreadyFound(ArrayList<Complex> solutions, Complex check){
  for (Complex solution : solutions){
    if (solution.equals(check)){
      return true;
    }
  }
  
  return false;
}

int count(String s, char c){
  int num = 0;
  for (int i = 0; i < s.length(); i++){
    if (s.charAt(i) == c){
      num ++;
    }
  }
  return num;
}
