import processing.serial.*;

final int samples = 64; //number of samples

int[][] dataArray = new int[2][600];
int[] dataArrayval = new int[2];
int[] dataArrayvalmin = new int[2];
int[] dataArrayvalmax = new int[2];
color[] dataArraycolor = {
  color(224, 24, 106),
  color(48, 105, 166),
  color(85, 130, 48)};

void mousePressed() {
  //reset min and max
  for(int a=0; a<dataArrayvalmin.length; a++) {
    dataArrayvalmin[a] = Integer.MIN_VALUE;
  }
  for(int a=0; a<dataArrayvalmax.length; a++) {
    dataArrayvalmax[a] = Integer.MAX_VALUE;
  }
}

Serial myPort;
void setup() {  
  size(600, 400);
  myPort = new Serial(this, "COM33",  9600);
  //center all variables
  for(int a=0; a<dataArrayval.length; a++) {
    for (int b=0; b<dataArray[a].length; b++) {   
      dataArray[a][b] = height/2;
    }
  }
  //reset min and max
  for(int a=0; a<dataArrayvalmin.length; a++) {
    dataArrayvalmin[a] = 0;
  }
  for(int a=0; a<dataArrayvalmax.length; a++) {
    dataArrayvalmax[a] = 1024;
  }
}

void draw()
{ 
  background(255); // white
  
  //draw paper
  for (int i=0; i<=width/10; i++) {      
    stroke(200);
    line((-frameCount%10)+i*10, 0, (-frameCount%10)+i*10, height);
    line(0, i*10, width, i*10);
  }
  
  //draw indication lines (90deg, 180deg, 270deg)
  stroke(0);
  for (int i=1; i<=3; i++)
    line(0, height/4*i, width, height/4*i);

  //write last data
  PFont f = createFont("Arial", 16, true);
  textFont(f,16);
  for(int a=0; a<dataArrayval.length; a++) {
    if(dataArrayval[a] > dataArrayvalmin[a])
      dataArrayvalmin[a] = dataArrayval[a];
    if(dataArrayval[a] < dataArrayvalmax[a])
      dataArrayvalmax[a] = dataArrayval[a];
    fill(dataArraycolor[a]);
    text(dataArrayval[a] + " (" + dataArrayvalmin[a] + " , " + dataArrayvalmax[a] + ")", 20, 20 + a*21);    
  } 
 
  //add data
  for(int a=0; a<dataArrayval.length; a++) {
    dataArray[a][dataArray[a].length-1] = (int)map(1024-dataArrayval[a], 0, 1024, 0, height);
  }
  
  //draw line
  for(int a=0; a<dataArrayval.length; a++) {
    noFill();
    stroke(dataArraycolor[a]);
    beginShape();
    for (int b=0; b<dataArray[a].length; b++) { 
      vertex(b, dataArray[a][b]); 
    }
    endShape();
  }
  
  //put all data one array back
  for(int a=0; a<dataArrayval.length; a++) {
    for (int b=1; b<dataArray[a].length; b++) { 
      dataArray[a][b-1] = dataArray[a][b];
    }
  }
}

void serialEvent (Serial arduino) {  
  byte[] buf = new byte[1024];
  int bufread = myPort.readBytesUntil((byte)10, buf);
    
  if(bufread == samples+1+2 +4) {
    int b = 0;
    int i = 0;
    for(i=0; i<samples+2; i=i+2) {
      int num = (short)((buf[i+1] & 0xff)<<8 | (buf[i] & 0xff));
    }
    dataArrayval[0] = (short)((buf[i+1] & 0xff)<<8 | (buf[i] & 0xff));
    i = i+2;
    dataArrayval[1] = (short)((buf[i+1] & 0xff)<<8 | (buf[i] & 0xff));
  }
}

