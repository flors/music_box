import codeanticode.syphon.*;
class SFD{
  public PGraphics canvas;
  public SyphonServer server;
  PApplet that;
  SFD(PApplet tthat){
    that = tthat;
    canvas = createGraphics(that.width, that.height, P3D);
    // Create syhpon server to send frames out.
    server = new SyphonServer(that, "Processing Syphon");
  }
 
  void update(){
    that.loadPixels();
    canvas.loadPixels();
    for(int i=0;i<that.pixels.length;i++){
      canvas.pixels[i] = that.pixels[i];
    }
    canvas.updatePixels();
    server.sendImage(canvas);
  }
}
