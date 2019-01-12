SFD send;//as a global

// import everything necessary to make sound.
import ddf.minim.*;
import ddf.minim.ugens.*;
import processing.serial.*;


//ARDUINO
Serial myPort;  // Create object from Serial class
String val = "-1";     // Data received from the serial port
int LDR1;
int LDR2;
int LDR3;
int LDR4;

//VISUAL
float inc = 0.0;
float inc3 = 0.0;
float t;

float h1;
float h2;
float h3;


color c1 =  color(8, 14, 25);//Dark blue
color c2 =  color(136, 100, 94);//pink
color c3 =  color(125, 131, 142);//light blue
color c4 =  color(142, 141, 132);//Gray
color c5 =  color(255, 255, 255);//Gray

color[] colors = {
  c1, c2, c3, c4 
};

float  pos1_end_a, pos1_end_b, pos2_end_a, pos3_end_a, pos4_end_a, 
  pos5_end_a, pos6_end_a, pos7_end_a;

//CONTROL
boolean hatActive = false;
boolean snareActive = false;
boolean kickActive = false;
boolean filterActive = false;
boolean nofilter = true;




//AUDIO
Minim minim;
AudioOutput out;
Oscil      wave;
Frequency  currentFreq;

// the type in the angle brackets lets the program
// know the type that should be returned by the ugen method of Bypass
Bypass<Delay> bypassedDelay;



void settings(){
  //size(842, 595, P2D);
  size(1400, 720, P2D);
  PJOGL.profile = 1;
}


// setup is run once at the beginning
void setup()
{
  // initialize the drawing window
  //size(1400, 500);
  send = new SFD(this);

  //ARDUINO
  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);

  //AUDIO
  // initialize the minim and out objects
  minim = new Minim(this);
  out   = minim.getLineOut();

  currentFreq = Frequency.ofPitch( "Do 3" );
  wave = new Oscil( currentFreq, 0.5f, Waves.SINE );

  //Delay

  // initialize myDelay with continual feedback and no audio passthrough
  Delay myDelay = new Delay( 0.6, 0.9, true, true );

  // create a Bypass to wrap the Delay so we can turn it on and off
  bypassedDelay = new Bypass<Delay>( myDelay );

  // create an LFO to be used for an amplitude envelope
  Oscil myLFO = new Oscil( 1, 0.3, Waves.square( 0.95 ) );
  // offset the center value of the LFO so that it outputs 0 
  // for the long portion of the duty cycle
  myLFO.offset.setLastValue( 0.3f );

  myLFO.patch( wave.amplitude );

  wave.patch( bypassedDelay ).patch( out );


  wave.patch( out );



  //VISUAL
  strokeWeight(5);
  background(colors[0]);

  h1 = 0;
  h2 = 0;
  h3 = 0;

  pos1_end_a = height/2 - 30;
  pos1_end_b = height/2 +20;


  pos2_end_a = height/2 - 30;
  pos3_end_a = height/2 - 30; 
  pos4_end_a = height/2 - 30; 
  pos5_end_a = height/2 - 30; 
  pos6_end_a = height/2 - 30; 
  pos7_end_a = height/2 - 30;
}


void draw()
{

  background(colors[0]);


  //ARDUINO DATA
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.readStringUntil('\n');         // read it and store it in val
  }

  if (val != null) {
    //println(val);

    String[] aux =  split(trim(val), '|');
    LDR1 = int(aux[0]);//Up-left
    //println("LDR1: " + LDR1);

    LDR2 = int(aux[1]);//Up right
    //println("LDR2: " + LDR2);

    LDR3 = int(aux[2]);//Front-left
    //println("LDR3: " + LDR3);

    LDR4 = int(aux[3]);//front-right
    //println("LDR4: " + LDR4);

    selectNote(LDR1);
    selectWaveForm(LDR2);
    //changeStateDelay(LDR3);
    changeDelayValues(LDR3,LDR4);


    // playHat(LDR2);
    // playSnare(LDR3);
    // playKick(LDR4);

    //VISUAL

    if ( bypassedDelay.isActive() )
    {
      text( "The Delay effect is bypassed.", 10, 15 );
    } else
    {
      text( "The Delay effect is active.", 10, 15 );
    }
    
    t = map(sin(inc), -1, 1, 0, 1);


    //START LINES 1
    h1 = lerp(height/2, pos1_end_a, t);
    drawAnimLines( h1, 0, 200, colors[1] );

    h2 = lerp(height/2 - 20, pos1_end_b, t);
    drawAnimLines( h2, 0, 200, colors[1] );

    h3 = lerp(height/2, height/2 + 30, t);
    drawAnimLines( h3, 0, 200, colors[1] );
    //END LINES 1

    //START LINES 2
    h1 = lerp(height/2, pos2_end_a, t);
    drawAnimLines( h1, 200, 400, colors[2] );

    h2 = lerp(height/2 - 20, pos1_end_b, t);
    drawAnimLines( h2, 200, 400, colors[2] );

    h3 = lerp(height/2, height/2 + 30, t);
    drawAnimLines( h3, 200, 400, colors[2]);
    //END LINES 2

    //START LINES 3
    h1 = lerp(height/2, pos3_end_a, t);
    drawAnimLines( h1, 400, 600, colors[3]);

    h2 = lerp(height/2 - 20, pos1_end_b, t);
    drawAnimLines( h2, 400, 600, colors[3] );

    h3 = lerp(height/2, height/2 + 30, t);
    drawAnimLines( h3, 400, 600, colors[3] );
    //END LINES 3

    //START LINES 4
    h1 = lerp(height/2, pos4_end_a, t);
    drawAnimLines( h1, 600, 800, colors[1] );

    h2 = lerp(height/2 - 20, pos1_end_b, t);
    drawAnimLines( h2, 600, 800, colors[1] );

    h3 = lerp(height/2, height/2 + 30, t);
    drawAnimLines( h3, 600, 800, colors[1] );
    //END LINES 4

    //START LINES 5
    h1 = lerp(height/2, pos5_end_a, t);
    drawAnimLines( h1, 800, 1000, colors[3] );

    h2 = lerp(height/2 - 20, pos1_end_b, t);
    drawAnimLines( h2, 800, 1000, colors[3] );

    h3 = lerp(height/2, height/2 + 30, t);
    drawAnimLines( h3, 800, 1000, colors[3]);
    //END LINES 5

    //START LINES 6
    h1 = lerp(height/2, pos6_end_a, t);
    drawAnimLines( h1, 1000, 1200, colors[2] );

    h2 = lerp(height/2 - 20, pos1_end_b, t);
    drawAnimLines( h2, 1000, 1200, colors[2] );

    h3 = lerp(height/2, height/2 + 30, t);
    drawAnimLines( h3, 1000, 1200, colors[2] );
    //END LINES 6

    //START LINES 6
    h1 = lerp(height/2, pos7_end_a, t);
    drawAnimLines( h1, 1200, 1400, colors[3] );

    h2 = lerp(height/2 - 20, pos1_end_b, t);
    drawAnimLines( h2, 1200, 1400, colors[3] );

    h3 = lerp(height/2, height/2 + 30, t);
    drawAnimLines( h3, 1200, 1400, colors[3] );
    //END LINES 6

    inc += .03;
    inc3 += .02;
  }
  
 // send.update();
}

//VISUAL
void drawAnimLines(float h, float x1, float x2, color lineColor) {
  float dist = x2 -x1;

  //ellipse(width/2, h, 10, 10);
  stroke(lineColor);
  line(x1, height/2, x1 + dist/2, h);
  line(x1 + dist/6, height/2, x1 + dist/2, h);
  line(x1 + dist/4, height/2, x1 + dist/2, h);

  line(x2, height/2, x1 + dist/2, h);
  line(x2 - dist/2 + dist/6, height/2, x1 + dist/2, h);
  line(x2 - dist/2 + 50, height/2, x1 + dist/2, h);
}


//SOUNDS



void changeStateDelay(int sensorValue) {
  int aux = int(map(sensorValue, 0, 70, 1, 6));

  if (aux >= 3) {

    if (!bypassedDelay.isActive()) {
      bypassedDelay.activate();
    }
  } else {

    if (bypassedDelay.isActive()) {
      bypassedDelay.deactivate();
    }
  }
}

void changeDelayValues(int sensorValue1, int sensorValue2) {

  int aux1 = int(map(sensorValue1, 0, 80, 0, width));
  int aux2 = int(map(sensorValue2, 0, 40, 0, height));

  // set the delay time by the horizontal location
  float delayTime = map( aux1, 0, width, 0.0001, 0.5 );
  bypassedDelay.ugen().setDelTime( delayTime );

  // set the feedback factor by the vertical location
  float feedbackFactor = map( aux2, 0, height, 0.0, 0.99 );
  bypassedDelay.ugen().setDelAmp( feedbackFactor );
  
 
  pos1_end_a = height/2 - random(aux2);
  pos1_end_b = height/2 + random(aux1);
}



void selectWaveForm(int sensorValue) {
  int aux = int(map(sensorValue, 1, 70, 1, 5));
  //println("Waveform: " + aux);

  switch( aux )
  {
  case 1: 
    wave.setWaveform( Waves.SINE );
    wave.setAmplitude( 1.0f );
    
    colors[1] =  c2;
    colors[2] =  c3;
    colors[3] =  c4;

    break;

  case 2:
    wave.setWaveform( Waves.TRIANGLE );
    wave.setAmplitude( 0.7f );
    
    colors[1] =  c3;
    colors[2] =  c2;
    colors[3] =  c4;
    break;

  case 3:
    wave.setWaveform( Waves.SAW );
    wave.setAmplitude( 0.5f );
    
    colors[1] =  c2;
    colors[2] =  c4;
    colors[3] =  c3;
    break;

  case 4:
    wave.setWaveform( Waves.SQUARE );
    wave.setAmplitude( 0.7f );
    
    colors[1] =  c4;
    colors[2] =  c3;
    colors[3] =  c2;
    break;

  case 5:
    wave.setWaveform( Waves.QUARTERPULSE );
    wave.setAmplitude( 0.7f );
 
    colors[1] =  c3;
    colors[2] =  c2;
    colors[3] =  c4;

    break;

  default: 
    break;
  }
}



void selectNote(int sensorValue) {
  int aux = int(map(sensorValue, 1, 70, 1, 13));
  //println(aux);

  switch(aux) {
  case 1:
    currentFreq = Frequency.ofPitch( "Do 3" );
    pos1_end_a = height/2 - 100;
    pos1_end_b = height/2 + 70;

    //println("Do 3");
    break;

  case 2:
    currentFreq = Frequency.ofPitch( "Do# 3" );
    pos1_end_a = height/2 - 100;
    pos1_end_b = height/2 + 70;
    //println("Do# 3");
    break;
  case 3:
    currentFreq = Frequency.ofPitch( "Re 3" );
    pos2_end_a = height/2 - 150;
    // println("Re 3");
    break;

  case 4:
    currentFreq = Frequency.ofPitch( "Re# 3" );
    pos2_end_a = height/2 - 150;
    // println("Re# 3");
    break;

  case 5:
    currentFreq = Frequency.ofPitch( "Mi 3" );
    pos3_end_a = height/2 - 135;
    //println("Mi 3");
    break;
  case 6:
    currentFreq = Frequency.ofPitch( "Fa 3" );
    pos4_end_a = height/2 - 200;
    //println("Fa 3");
    break;
  case 7:
    currentFreq = Frequency.ofPitch( "Fa# 3" );
    pos4_end_a = height/2 - 200;
    //println("Fa# 3");
    break;
  case 8:
    currentFreq = Frequency.ofPitch( "Sol 3" );
    pos5_end_a = height/2 - 120;
    //println("Sol 3");
    break;
  case 9:
    currentFreq = Frequency.ofPitch( "Sol# 3" );
    pos5_end_a = height/2 - 120;
    //println("Sol #3");
    break;
  case 10:
    currentFreq = Frequency.ofPitch( "La 3" );
    pos6_end_a = height/2 - 150;
    //println("La 3");
    break;
  case 11:
    currentFreq = Frequency.ofPitch( "La# 3" );
    pos6_end_a = height/2 - 150;
    //println("La# 3");
    break;
  case 12:
    currentFreq = Frequency.ofPitch( "Si 3" );
    pos7_end_a = height/2 - 180;
    //println("Si 3");
    break;
  case 13:
    currentFreq = Frequency.ofPitch( "Do 4" );
    //println("Do 4");
    break;

  default: 
    /*pos1_end_a = height/2 - 30;
     pos2_end_a = height/2 - 30;
     pos3_end_a = height/2 - 30; 
     pos4_end_a = height/2 - 30; 
     pos5_end_a = height/2 - 30; 
     pos6_end_a = height/2 - 30; 
     pos7_end_a = height/2 - 30; 
     
     pos1_end_b = height/2 + 20;*/
    break;
  }


  wave.setFrequency( currentFreq );
}
