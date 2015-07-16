ArrayList<PImage> pics = new ArrayList<PImage>();

void setup() {
  for (int i=0; i<36; i++) {
    pics.add(loadImage("../capturer/cards/c"+i+".png"));
  }
  size(pics.get(0).width,pics.get(0).height);
  println(absDif(pics.get(6), pics.get(0)));
  //image(minDif(pics.get(2),pics), 0, 0);
}

void draw() {
}

long absDif(PImage a, PImage b) {
  a.loadPixels();
  int[] aa = a.pixels;
  b.loadPixels();
  int[] bb = b.pixels;
  int[] cc = new int[aa.length];
  for (int i=0; i<aa.length; i++) {
    cc[i] = abs(aa[i]-bb[i]);
  }
  long ret = 0L;
  for (int i=0; i<aa.length; i++) {
    ret += cc[i];
  }
  loadPixels();
  for (int i=0; i<aa.length; i++) {
    pixels[i] = color((int)cc[i]);
  }
  updatePixels();
  return ret;
  //return 0;
}

PImage minDif(PImage a, ArrayList<PImage> L) {
  long dif = absDif(a, L.get(0));
  int ret = 0;
  for (int i=0; i<L.size (); i++) {
    long b = absDif(a, L.get(i));
    //dif = min(b, dif);
    if (b<dif) {
      dif=b;
      ret=i;
    }
  }
  println(dif);
  return L.get(ret);
}

