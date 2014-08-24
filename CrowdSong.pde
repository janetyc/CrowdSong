import ddf.minim.*;
import ddf.minim.analysis.*;
Minim minim;

AudioPlayer[][] sounds = new AudioPlayer[69][3];
int[][] playStatus = new int[69][3];
PVector[][] soundVector = new PVector[69][3];

int rectSize = 5;
int ratio=1;
int currentPos=0;
int prevPos=0;
float move=0.0;

ArrayList<AudioPlayer> currentList;
ArrayList<PVector> currentSound;
void setup(){
  size(1080/ratio,1920/ratio);
  background(0);
  
  minim = new Minim(this);
  currentList = new ArrayList<AudioPlayer>();
  currentSound = new ArrayList<PVector>();
  
  randomRhythm();
  currentPos = -1;
}

void draw(){
  noStroke();
  fill(0,0,0,random(3,5));
  rect(0,0,width,height);
  if(!currentTrackIsPlaying(currentList)){
    currentPos = currentPos +1;
    move = 0;
    
    if(currentPos >= 0 && currentPos <= 68){
      if(currentPos > 0){
        stopTrack(currentPos-1);
      }
      playTrack(currentPos);
    }
    
    if(currentPos > 68){
      reset();
    }
    
    prevPos = currentPos;
  }
  move = move + random(3);
  
  drawCurrentTrack(currentPos);
  drawFFT(currentList,currentPos);
}


void randomRhythm(){
  for(int i=0; i<69; i++){
    for(int j=0; j<3; j++){
      if(int(random(2)) == 1){
        playStatus[i][j] = 1;
      }else{
        playStatus[i][j] = 0;
      }
      soundVector[i][j] = new PVector(int(random(0, width)),int(random(0, height)),int(random(3)));
    }
    
    //make sure at least sound play
    playStatus[i][int(random(3))] = 1;
  }
}

void playSound(int i, int j){
  //sounds[i][j].trigger();
  String fname = nf(i+1, 3)+"_"+str(j+1)+".mp3";
  //println("load "+fname);
  sounds[i][j] = minim.loadFile(fname, 512);
  //println("play "+fname);
  sounds[i][j].play();
  currentList.add(sounds[i][j]);
  currentSound.add(soundVector[i][j]);
}

void stopSound(int i, int j){
  sounds[i][j].pause();
  sounds[i][j].close();
}

void playTrack(int i){
  for(int j=0; j<3; j++){
    if(playStatus[i][j] == 1){
      playSound(i,j);
    }
  }
}


void stopTrack(int i){
  //println("stop Track:"+i);
  for(int j=0; j<3; j++){
    if(playStatus[i][j] == 1){
      stopSound(i,j);
    }
  }
}

boolean currentTrackIsPlaying(ArrayList<AudioPlayer> list){
  boolean isPlay = false;
  
  for(int k=0; k<list.size(); k++){
    if(list.get(k).isPlaying()){
      isPlay = isPlay || list.get(k).isPlaying();
    }else{
      list.remove(k);
      currentSound.remove(k);
    }
  }
  
  return isPlay;
}
void drawCurrentTrack(int currentTrack){
  
  for(int j=0; j<3; j++){
    for(int i=0; i<69; i++){
      if(playStatus[i][j] == 1){
        if(i == currentTrack){         
          fill(255,24,163);
        }
        else{
          fill(255);
        }
      }else{
        noFill();
      }
      noStroke();
      rect(i*(rectSize+1),j*(rectSize+1),rectSize,rectSize);
      //ellipse(soundVector[i][j].x, soundVector[i][j].y, 3, 3);
    }
  }
  
}

void reset(){
  minim.stop();
  minim = null;
  sounds = null;
  playStatus = null;
  soundVector = null;
  System.gc();
  
  minim = new Minim(this);
  sounds = new AudioPlayer[69][3];
  playStatus = new int[69][3];
  soundVector = new PVector[69][3];
  
  randomRhythm();
  currentPos = -1;
  
}

void drawFFT(ArrayList<AudioPlayer> list, int currentTrack){
  for(int k=0; k< list.size(); k++){
    
    stroke(255,255,255, random(0,255));
    AudioPlayer p = list.get(k);
    for(int i = 0; i < p.bufferSize() - 1; i++)
    {
      float x1 = map( i, 0, p.bufferSize(), 0, width );
      float x2 = map( i+1, 0, p.bufferSize(), 0, width );
      line(0, move+currentSound.get(k).y, width, move+currentSound.get(k).y);
      line( x1, move+currentSound.get(k).y + p.left.get(i)*random(100, 170), x2, move+currentSound.get(k).y + p.left.get(i+1)*random(100, 170) );      
      //line( x1, 150 + p.right.get(i)*50, x2, 150 + p.right.get(i+1)*50 );
      
    }
    
  }
}

