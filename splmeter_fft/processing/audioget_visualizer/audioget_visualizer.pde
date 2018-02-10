import processing.serial.*;

//constant
final int F = 22050; //sampled frequency
final int samples = 64; //number of samples

//variables
float[] magnitude = new float[(samples/2)+1];
int rms = 0;
int spl = 0;

//fft graph
Graph spectrumGraph = new Graph(150, 200, 500, 400, color(20,20,200));
//serial port
Serial myPort;


/*
setup function
*/
void setup() {
  size(800, 700); 
  myPort = new Serial(this, "COM33", 9600);
   
  spectrumGraph.xLabel="Frequency";
  spectrumGraph.yLabel="Amplitude";
  spectrumGraph.Title="Spectrum";
  spectrumGraph.xMax=F/2;   
  spectrumGraph.xDiv=5;
  spectrumGraph.yMax=100;
  spectrumGraph.yMin=0;
}


/*
main draw loop
*/
void draw() {
  background(255);
  
  spectrumGraph.DrawAxis();
  spectrumGraph.Bar(magnitude);
  
  fill(0);
  textAlign(LEFT);
  textSize(20);
  text("rms: " + rms, 100, 70);
  text("spl: " + spl, 100, 100);
}


/*
read from serial port
*/
void serialEvent(Serial myPort) {
  byte[] buf = new byte[1024];
  int bufread = myPort.readBytesUntil((byte)10, buf);
    
  if(bufread == samples+1+2 +4) {
    int b = 0;
    int i = 0;
    for(i=0; i<samples+2; i=i+2) {
      int num = (short)((buf[i+1] & 0xff)<<8 | (buf[i] & 0xff));
      magnitude[b] = (float)num/100;
      b++;
    }
    rms = (short)((buf[i+1] & 0xff)<<8 | (buf[i] & 0xff));
    i = i+2;
    spl = (short)((buf[i+1] & 0xff)<<8 | (buf[i] & 0xff));
  }
}
