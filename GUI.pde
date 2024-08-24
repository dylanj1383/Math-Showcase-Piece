class Menu{
  float menuWidth;
  Dropdown selectFunction;
  Dropdown isFactored;
  Dropdown plotReciprocal;
  Dropdown plotInverse;
  TextInput typeFunction;
  
  Menu(float m, Dropdown d, TextInput t){
    this.menuWidth = m;
    this.selectFunction = d;
    this.typeFunction = t;
    
    String[] options = {"Factored Form", "Standard Form"};
    Dropdown df = new Dropdown(new PVector(width/9.0 + 150, 100), grey2, white1, black, options, "Standard Form");
    this.isFactored = df;
    
    String[] options2 = {"Plot 1/f(x)", "Don't Plot 1/f(x)"};
    Dropdown pf = new Dropdown(new PVector(width/9.0 + 300, 100), grey2, white1, black, options2, "Don't Plot 1/f(x)");
    this.plotReciprocal = pf;
    
    String[] options3 = {"Plot Inverse", "Don't Plot Inverse"};
    Dropdown iF = new Dropdown(new PVector(width/9.0 + 150, 100), grey2, white1, black, options3, "Don't Plot Inverse");
    this.plotInverse = iF;
    
  }
  
  void drawMenu(){
    stroke(255);
    fill(255);
    //line(this.menuWidth, 0, this.menuWidth, height);
    textAlign(TOP, LEFT);
    textSize(13);
    text("Function Type:", 54, 80);
    text("f(x)= ", 54, 320+20);
    text("Scroll to zoom graph.", 800, 560);
    text("Press 'r' to reset graph zoom.", 800, 580);
    
    
    Function f = this.getFunction();
    try{
    if (f!=null){
      f.plotOnPlane(plane);
      stroke(primaryFunctionCol);
      fill(primaryFunctionCol);
      textAlign(TOP, LEFT);
      textSize(14);
      
      String functionText = "f(x) = " + f.getFunctionString();
      
      if(functionText.length() > 70){
        text(functionText.substring(0, 70), 54, 340+40);
        text(functionText.substring(70, functionText.length()), 54, 360+40);
      }else{
        text(functionText, 54, 340+40);
      }
      
      if (f.type.equals("polynomial")||f.type.equals("rational")){
        String factoredText = "f(x) = " + f.getFactoredFunctionString();
        if(factoredText.length() > 70){
          text(factoredText.substring(0, 70), 54, 380+40);
          text(factoredText.substring(70, factoredText.length()), 54, 400+40);
        }else{
          text(factoredText, 54, 380+40);
        }
      }
      
      
      textSize(13);
      text("Intercepts of f(x):", 54, 460+40);
      stroke(255); fill(255);
      text(f.getYIntString(), 54, 480+40);
      text(f.getXIntString(), 54, 500+40);
    }
    } catch (Exception e){}
    
    
    Function f2 = this.getSecondaryFunction();
    try{
    if (f2!=null){
      f2.plotOnPlane(plane);
      stroke(secondaryFunctionCol);
      fill(secondaryFunctionCol);
      textAlign(TOP, LEFT);
      textSize(14);
      String functionDef;
      int marginVal;
      if (f2.type.equals("exponential") || f2.type.equals("logarithmic")){
        functionDef = "f^-1(x) = ";
        marginVal = 0;
      }
      else{
        functionDef = "1/f(x) = ";
        marginVal = 20;
      }
      
      String functionText = functionDef + f2.getFunctionString();
      
      
      if(functionText.length() > 70){
        text(functionText.substring(0, 70), 54, 400 + marginVal+40);
        text(functionText.substring(70, functionText.length()), 54, 420+marginVal+40);
      }else{
        text(functionText, 54, 400+marginVal+40);
      }
    }
    } catch (Exception e){}
    
    //add messages for how to enter polynomials
    fill(255);
    textSize(13);
    if (selectFunction.getText().equals("Polynomial")){
      if (isFactored.getText().equals("Factored Form")){
        text("Please enter a polynomial in factored form:", 54, 140);
        text("(factor)(factor)(factor)...", 54, 160);
        text("Every factor, including stretch coefficients, should be in brackets.", 54, 180);
        text("Each factor should follow the standard form specifications.", 54, 200);
        text("Sample inputs: (x^3 + 2x^2 - 1)(x+1)(x-1)", 54, 220);
        text("                                 (0.1)(x)(0.2x)(x+4)(x+2)(x-2)(x^2+1)", 54, 240);
        text("There should be nothing between factors. e.g. (x+3)-(x-1) is not permitted.", 54, 260);
        text("There should be no nested brackets", 54, 280);
        text("Spaces can be added if desired. They are not necessary.", 54, 300);
      }
      else{
        text("Please enter a polynomial as a collection of terms:", 54, 140);
        text("All terms must be separated by '+' or '-'", 54, 160);
        text("All exponents, if present, should be preceded by 'x^'", 54, 180);
        text("All exponents should be integers greater than or equal to 0.", 54, 200);
        text("Exponents should not follow '+' or '-'. These are to separate terms", 54, 220);
        text("Sample inputs: x^4 - 3x^2 + x^4 - 5 + 7x", 54, 240);
        text("                                 5x^2", 54, 260);
        text("                               -7 + 5 - x^1 + x^0", 54, 280);
        text("Spaces can be added if desired. They are not necessary.", 54, 300);
      }
    }
    else if (selectFunction.getText().equals("Rational")){
      text("Please enter a rational function of the form (num)/(den).", 54, 140);
      text("If entered as above, num and den are polynomials given as terms.", 54, 160);
      text("The numerator and denominator can be given in the factored form:", 54, 180);
      text("   (nfactor)(nfactor)...(nfactor)/(dfactor)(dfactor)...(dfactor)", 54, 200);
      text("Other specifications follow polynomial inputs specifications.", 54, 220);
      text("Holes and asymptotes should be handled and plotted.", 54, 240);
      text("Sample inputs: (x^3 + 2x^2 - 1)/(x + 3)", 54, 260);
      text("                               (x)(x+4)(x^2-4)/(x)(x+3)(x-4)(x+1)(x+2)", 54, 280);
      text("Spaces can be added if desired. They are not necessary.", 54, 300);
    }
    else if (selectFunction.getText().equals("Logarithmic")){
      // a*log_b(k(x-p)) + q or alog_b(k(x-p)) + q
      text("Please enter an logarithmic function of the form a*log_b(k(x-p)) + q.", 54, 140);
      text("Values you would normally omit, such as 1 and 0, are not necessary.", 54, 160);
      text("Sample inputs: -ln(3(x+3)) - 6", 54, 180);
      text("                             3log_2(x+4) - 4", 54, 200);
      text("                             -3*log(x) - 8", 54, 220);
      text("The base must be a positive real number, excluding 1.", 54, 240);
      text("The argument to the logarithm must always be surrounded in brackets.", 54, 260);
      text("'Reg flags' are allowed. Use nested brackets only if necessary.", 54, 280);
      text("Spaces can be added if desired. They are not necessary.", 54, 300);
    }
    else if (selectFunction.getText().equals("Exponential")){
      //a*b^(k(x+p)) + q
      text("Please enter an exponential function of the form a*b^(k(x-p)) + q. ", 54, 140);
      text("Values you would normally omit, such as 1 and 0, are not necessary.", 54, 160);
      text("Sample inputs: -e^(-5(x+3)) - 4", 54, 180);
      text("                             5*3^(x+3)", 54, 200);
      text("                             2^(2x+1)", 54, 220);
      text("The base must be a positive real number, excluding 1.", 54, 240);
      text("'Reg flags' are allowed. Use nested brackets only if necessary.", 54, 260);
      text("An a-value should be followed by '*', except as shown in the examples.", 54, 280);
      text("Spaces can be added if desired. They are not necessary.", 54, 300);

    }
    
    
    
    //add special dropdowns
    if (selectFunction.getText().equals("Polynomial")){
      //add another dropdown for factored form or standard form
      this.isFactored.drawDropdown();
    }
    if (selectFunction.getText().equals("Polynomial") || selectFunction.getText().equals("Rational")){
      this.plotReciprocal.drawDropdown();
    }
    if (selectFunction.getText().equals("Exponential") || selectFunction.getText().equals("Logarithmic")){
      this.plotInverse.drawDropdown();
    }
    
    this.typeFunction.drawTextInput();
    this.typeFunction.updateCursor();
    this.selectFunction.drawDropdown();
  }
  
  void mousePressed(){
    this.selectFunction.mousePressed();
    this.typeFunction.mousePressed();
    if (selectFunction.getText().equals("Polynomial")){
      this.isFactored.mousePressed();
    }
    if (selectFunction.getText().equals("Polynomial") || selectFunction.getText().equals("Rational")){
      this.plotReciprocal.mousePressed();
    }
    if (selectFunction.getText().equals("Exponential") || selectFunction.getText().equals("Logarithmic")){
      this.plotInverse.mousePressed();
    }
  }
  
  void keyPressed(){
    this.typeFunction.keyPressed();
  }
  
  Function getFunction(){
    String functionType = this.selectFunction.getText();
    String functionText = this.typeFunction.getText();
    try{
      if (functionType.equals("Polynomial")){
        if (this.isFactored.getText().equals("Factored Form")){
          Polynomial p = new Polynomial("factored", functionText, primaryFunctionCol);
          return p;
        }
        else{
          Polynomial p = new Polynomial(functionText, primaryFunctionCol);
          return p;
        }
      }
      else if (functionType.equals("Rational")){
        Rational r = new Rational(functionText, primaryFunctionCol);
        return r;
      }
      else if (functionType.equals("Logarithmic")){
        Logarithmic l = new Logarithmic(functionText, primaryFunctionCol);
        return l;
      }
      else if (functionType.equals("Exponential")){
        Exponential ef = new Exponential(functionText,primaryFunctionCol);
        return ef;
      }
      else{
        return null;
      }
    }
    catch (Exception e){
      println("Invalid function type or string input.");
      return null;
    }
  }
  
  Function getSecondaryFunction(){
    String functionType = this.selectFunction.getText();
    String functionText = this.typeFunction.getText();
    
    try{
      if (functionType.equals("Polynomial") || functionType.equals("Rational")){
        
        if (this.plotReciprocal.getText().equals("Plot 1/f(x)")){
          if (functionType.equals("Polynomial")){
            Polynomial p;
            if (this.isFactored.getText().equals("Factored Form")){
              p = new Polynomial("factored", functionText, primaryFunctionCol);
            }
            else{
              p = new Polynomial(functionText, primaryFunctionCol);
            }
            Reciprocal rec = new Reciprocal(p, secondaryFunctionCol);
            return rec;
          }
          else if (functionType.equals("Rational")){
            Rational r = new Rational(functionText, primaryFunctionCol);
            Reciprocal rec = new Reciprocal(r, secondaryFunctionCol);
            return rec;
          }
          
        }
        
      }
      else if (selectFunction.getText().equals("Exponential") || selectFunction.getText().equals("Logarithmic")){
        if (this.plotInverse.getText().equals("Plot Inverse")){
          if (functionType.equals("Exponential")){
            Exponential ef = new Exponential(functionText, primaryFunctionCol);
            return ef.getInverse(secondaryFunctionCol);
          }
          else if (functionType.equals("Logarithmic")){
            Logarithmic l = new Logarithmic(functionText, primaryFunctionCol);
            return l.getInverse(secondaryFunctionCol);
          }
        }
      }
      return null;
    }
    catch (Exception e){
      return null;
    }
  }
}

class TextInput {
  String currentString;
  String defaultText;
  PVector pos;
  int boxWidth = 400;
  int boxHeight = 30;
  boolean selected;
  int cursorBlinkInterval = 400; // Cursor blink interval in frames
  int lastCursorBlinkTime;
  boolean cursorVisible;

  TextInput(PVector pos, String defaultText) {
    this.pos = pos;
    this.defaultText = defaultText;
    this.currentString = "";
    this.selected = false;
    this.lastCursorBlinkTime = millis();
    this.cursorVisible = true;
  }

  void drawTextInput() {
    // Draw text input box
    stroke(0);
    fill(255);
    rect(pos.x, pos.y, boxWidth, boxHeight);

    // Draw text
    fill(0);
    textAlign(LEFT, CENTER);
    String displayText = (currentString.isEmpty() && !selected) ? defaultText : currentString;
    text(displayText, pos.x + 5, pos.y + boxHeight / 2);

    // Draw cursor if selected
    if (selected && cursorVisible) {
      float cursorX = pos.x + textWidth(displayText) + 7;
      line(cursorX, pos.y + 5, cursorX, pos.y + boxHeight - 5);
    }
  }

  void keyPressed() {
    if (selected) {
      if ( (key == BACKSPACE ||key == DELETE) && currentString.length() > 0) {
        currentString = currentString.substring(0, currentString.length() - 1);
      } else if (key != CODED && key != ENTER && textWidth(currentString + key) < boxWidth - 15) {
        currentString += key;
      }
    }
  }

  void mousePressed() {
    if (mouseX > pos.x && mouseX < pos.x + boxWidth && mouseY > pos.y && mouseY < pos.y + boxHeight) {
      selected = true;
      // Maintain the existing content of the text box
      lastCursorBlinkTime = millis();
      cursorVisible = true;
    } else {
      selected = false;
    }
  }


  void updateCursor() {
    if (selected && millis() - lastCursorBlinkTime > cursorBlinkInterval) {
      cursorVisible = !cursorVisible;
      lastCursorBlinkTime = millis();
    }
  }
  
  String getText(){
    return this.currentString;
  }
}


class Dropdown {
  PVector pos;
  color darkColor;
  color lightColor;
  color textColor;
  String[] allOptions;
  String selectedString;
  boolean activated;
  int hoveredOptionIndex = -1; // Index of the option currently being hovered over
  float buttonWidth = 120; // Width of the dropdown button
  float buttonHeight = 30; // Height of the dropdown button
  float optionHeight = 30; // Height of each dropdown option
  
  Dropdown(PVector pos, color darkColor, color lightColor, color textColor, String[] allOptions, String selectedString) {
    this.pos = pos;
    this.darkColor = darkColor;
    this.lightColor = lightColor;
    this.textColor = textColor;
    this.allOptions = allOptions;
    this.selectedString = selectedString;
    this.activated = false;
  }
  
  void drawDropdown() {
    // Draw dropdown button
    stroke(0);
    fill(activated ? lightColor : darkColor);
    rect(pos.x-buttonWidth/2.0, pos.y-buttonHeight/2.0, buttonWidth, buttonHeight);
    fill(textColor);
    textAlign(CENTER, CENTER);
    text(selectedString, pos.x , pos.y );
    
    // Draw dropdown options if activated
    if (activated) {
      for (int i = 0; i < allOptions.length; i++) {
        float optionY = pos.y + buttonHeight + i * optionHeight;
        boolean isHovered = mouseX > pos.x - buttonWidth/2.0  && mouseX < pos.x + buttonWidth/2.0 && mouseY > optionY-optionHeight/2.0 && mouseY < optionY + optionHeight/2.0;
        if (isHovered) {
          hoveredOptionIndex = i;
          fill(lightColor);
        } else {
          fill(darkColor);
        }
        rect(pos.x - buttonWidth/2.0, optionY-optionHeight/2.0, buttonWidth, optionHeight);
        fill(textColor);
        text(allOptions[i], pos.x , optionY );
      }
    }
  }
  
  void mousePressed() {
    if (mouseX > pos.x-buttonWidth/2.0 && mouseX < pos.x + buttonWidth/2.0 && mouseY > pos.y-buttonHeight/2.0 && mouseY < pos.y + buttonHeight/2.0) {
      activated = !activated;
    } else if (activated) {
      for (int i = 0; i < allOptions.length; i++) {
        float optionY = pos.y + buttonHeight + i * optionHeight;
        if (mouseX > pos.x-buttonWidth/2.0 && mouseX < pos.x + buttonWidth/2.0 && mouseY > optionY-optionHeight/2.0 && mouseY < optionY + optionHeight/2.0) {
          selectedString = allOptions[i];
          activated = false; // Close dropdown after selection
          break;
        }
        activated = false;
      }
    }
  }
  
  
  String getText(){
    return this.selectedString;
  }
}
