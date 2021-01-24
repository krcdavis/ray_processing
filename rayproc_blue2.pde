PImage picyot;
//color, point3 and vec3 are all just vec3/PVector with funny names

//color blue_shade(PVector r)
//or

//this just holds 2 vec3s
class ray{
  //public:
  ray(){}
  ray(PVector origin, PVector direc){
   orig=origin;
   dir=direc;}
  PVector origin() {return orig;}
  PVector direc() {return dir;}
  PVector at(float t){
    return PVector.add(orig, (dir.mult(t)));
  }
  
  //public:
  PVector orig;
  PVector dir;
};

class camera{
  camera(){
    asp=16.0/9.0;
    vph= 2.0;
    focl=1.0;
    vpw= asp*vph;
  
    orign= new PVector(0,0,0);
    horiz= new PVector(vpw,0,0);
    verti= new PVector(0,vph,0);
 // PVector fopv= new PVector(0,0,focl);
  //do you think god stays in his heaven because he fears what he's created on earth?
  //PVector llc= PVector.sub(PVector.sub(orign, horiz.div(2.0)), PVector.sub(verti.div(2.0), fopv));
    llc= new PVector(-vpw/2,-vph/2,-focl);
  }
  
  ray get_ray(float u, float v){
     PVector peen= PVector.add(PVector.add(llc, PVector.mult(horiz, u)), PVector.sub(PVector.mult(verti,v), orign));
    return new ray(orign,peen);
  }
    
  PVector orign;
  PVector llc;
  PVector horiz;
  PVector verti;
  float focl;
  float vph;
  float vpw;
  float asp;
  
}


float hitSphere(PVector centr, float radius, ray r){
  PVector oc= PVector.sub(r.origin(), centr);
  float a= r.direc().magSq();
  float hb= PVector.dot(oc, r.direc());
  float c= oc.magSq() -radius*radius;
  float discm= hb*hb-a*c;//sing the song
  if (discm<0){
    return -1.0;
  }
  return (-hb - sqrt(discm))/a;
}
//*/

color shadeBlue(ray r){
  float t= hitSphere(new PVector(0,0,-1), 0.5,r);
  if (t>0.0){
    PVector N= PVector.sub(r.at(t), new PVector(0,0,-1));
    N.normalize();
    //N.mult(.5);
    //N.y=0-N.y;//why?
    float a=1.0;
    N.add(a,a,a);
    float g=128.0;
    return color((N.x)*g,(N.y)*g,(N.z)*g);
  }
  
  PVector u_dir= r.direc();//?
  u_dir.normalize();
  t= 0.5*(u_dir.y+1.0);
  color w= color(255,255,255);
  color b= color(128,178,255);
  return lerpColor(w,b,t);
  //return lerpColor(b,w,t);
  //return (1.0-t)*color(255,255,255)*t*color(128,200,255);//wtf
}
//*/

//w,h
void setup (){
  size(640,360);
  
  float asp=16.0/9.0;
  int imgw=600;
  int imgh= int(imgw/asp);
  //int imgw=640, imgh=300;
  //float rw=255.0/imgw, rh=255.0/imgh;
  picyot=createImage(imgw,imgh,RGB);
  
  //gamera
  camera cam = new camera();
  
  //doot thing
  picyot.loadPixels();
  for (int hi=0;hi<imgh;hi++){//heoght index
    for(int wj=0;wj<imgw;wj++){//width jndex
     //picyot.pixels[hi*imgw+wj] = color(int(rh*hi),int(rw*wj),256/4);
     float u= float(wj)/(imgw-1);
     float v= 1-(float(hi)/(imgh-1));
     //ray r=(orign, PVector.add(PVector.add(llc, PVector.mult(horiz, u)), PVector.sub(PVector.mult(verti,v), orign)));
     //PVector peen= PVector.add(PVector.add(cam.llc, PVector.mult(cam.horiz, u)), PVector.sub(PVector.mult(cam.verti,v), cam.orign));
     ray r= cam.get_ray(u,v);
     picyot.pixels[hi*imgw+wj] = shadeBlue(r);
    }
  }
  picyot.updatePixels();
}

void draw(){
  image(picyot,0,0);
}
