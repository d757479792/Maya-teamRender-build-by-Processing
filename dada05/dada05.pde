import java.io.File;
import g4p_controls.*;
//text 01 
GTextArea tx01;
GTextArea tx02;
GTextArea tx03;
GButton _confirm01;
GButton _confirm02;
GTextField _sf;
GTextField _ef;
GTextField _tn;
//
GOption[] optMmessType;
GToggleGroup opgMmessType;
//
PrintWriter output;
//
int md_mtype;
//
//String[] allPath;
ArrayList<String> allPath = new ArrayList<String>();
//
int bgcol = 32;
PFont _chn;
void setup() {
  //a font create
  _chn = createFont("chn.ttf", 32);
  G4P.setInputFont("chn", G4P.PLAIN, 14);
  size(400, 600);
  //
  tx01 = new GTextArea(this, 20, 70, 360, 50, G4P.SCROLLBARS_VERTICAL_ONLY | G4P.SCROLLBARS_AUTOHIDE);
  tx01.setPromptText("Please enter project path");
  //
  _confirm01 = new GButton(this, 160, 500, 80, 30, "Generate");
  //
  tx02 = new GTextArea(this, 20, 130, 360, 50, G4P.SCROLLBARS_VERTICAL_ONLY | G4P.SCROLLBARS_AUTOHIDE);
  tx02.setPromptText("Please enter Render.exe path");
  tx03 = new GTextArea(this, 20, 330, 360, 50, G4P.SCROLLBARS_VERTICAL_ONLY | G4P.SCROLLBARS_AUTOHIDE);
  tx03.setPromptText("Please enter Output path");
  //
  _sf = new GTextField(this, 100, 195, 120, 20);
  _ef = new GTextField(this, 100, 235, 120, 20);
  _tn = new GTextField(this, 100, 435, 120, 20);
  //
  //checkbox 
  String[] t = new String[] { 
    "Arnold", "Redshift", "default"
  };
  //
  opgMmessType = new GToggleGroup();
  optMmessType = new GOption[t.length]; 
  for (int i = 0; i < optMmessType.length; i++) {
    int x = 0;
    if (x == 2) {
      x = 20;
    }
    optMmessType[i] = new GOption(this, x+20+i*100, 290, 94, 18);
    optMmessType[i].setLocalColorScheme(GCScheme.SCHEME_11);
    optMmessType[i].setText(t[i]);
    optMmessType[i].tagNo = 9000 + i;
    opgMmessType.addControl(optMmessType[i]);
  }
  md_mtype = 0;
  optMmessType[md_mtype].setSelected(true);
  //
}
void draw() {
  background(bgcol);
  fill(227, 230, 255);
  noStroke();
  textSize(30);
  textFont(_chn);
  text("DADARENDER_V01", 20, 40);
  textSize(14);
  text("start frame", 20, 210);
  text("end frame", 20, 250);
  text("set name", 20, 450);
}
//blend btn event
public void handleButtonEvents(GButton button, GEvent event) { 
  if (button == _confirm01) {
    //
    //
    //01
    //get tx01_content
    String tx01_content = tx01.getText();
    String before = tx01_content;
    tx01_content = tx01_content.replace('\\', '/');
    //get all maya project dictionary
    File f = new File(tx01_content);
    if (!f.exists()) {
      println(tx01_content + " not exists");
      return;
    }
    //maya project dictionary array
    File fa[] = f.listFiles();
    //create maya project name array
    //int num = 0;
    for (int i = 0; i < fa.length; i++) {
      File fs = fa[i];
      if (fs.isFile()) {
        allPath.add(fs.getName());
        //num++;
      }
    }
    // lazy do not wanna to correct old code ,so create this ArrayList
    ArrayList<String> tx01_content_buffer = allPath;
    //
    //
    //02
    //get input Dictionary String
    String bufferbtn = "";
    //render.exe path
    String tx02_content = tx02.getText();
    tx02_content = "\"" +tx02_content+"\\Render.exe"+"\"";
    //render img path
    String tx03_content = tx03.getText();
    //frame range path
    String sf = _sf.getText();
    String ef = _ef.getText();
    //
    //03
    //render img path
    String tx03_content02;
    for (int i = 0; i<tx01_content_buffer.size(); i++) {
      if (tx01_content_buffer.size()>1) {
        //
        //correct path \ to /
        String tx03_content01 = tx03_content.replace('\\', '/');
        //new render fold name , 1,2,3,4......
        String num01 = i+"";
        //
        //combine new dictionary String
        tx03_content02 = tx03_content+"/"+num01;
        //
        //f01 is render path
        //f02 is the correct path
        File f01 = new File(tx03_content01);
        File f02 = new File(tx03_content02);
        //
        //mkdir(),creat path
        if (f01.getParentFile().exists()) {
          try {
            f02.mkdir();
          } 
          catch (Exception e) {
            e.printStackTrace();
          }
        }
      } else {
        tx03_content02  = tx03_content;
      }
      //
      //04
      //final path
      tx01_content_buffer.set(i, tx03_content02+" "+before+"\\"+tx01_content_buffer.get(i));
      bufferbtn += tx02_content;
      if (sf!="" && ef!="") {
        String temp = " -s "+sf+" -e "+ef;
        bufferbtn += temp;
      }
      if (md_mtype == 0) {
        bufferbtn +=" -r arnold";
      }
      bufferbtn +=(" -rd "+tx01_content_buffer.get(i));
      if (i!= tx01_content_buffer.size()-1 ) {
        bufferbtn += " & ";
      }
    }
    //
    //05
    //bat name
    String textName = _tn.getText();
    //out put bat
    output = createWriter("../"+textName+".bat"); 
    output.println(bufferbtn);
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    //
  }
}
   //06
   //arnold == 0 ;checkbox.tagNo % 9000 = 0
   //blend checkbox event
public void handleToggleControlEvents(GToggleControl checkbox, GEvent event) {
  md_mtype = checkbox.tagNo % 9000;
}
