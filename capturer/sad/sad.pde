ArrayList<PImage> pics = new ArrayList<PImage>();

void setup() {
  for (int i=0; i<36; i++) {
    pics.add(loadImage("../../capturer/cards/c"+i+".png"));
  }
  PImage a = loadImage("test/c27.png");
  size(pics.get(0).width, pics.get(0).height);
  println(absDif(a, pics.get(11),true));
  println(absDif(a, pics.get(11),!true));
  println(absDif(a, pics.get(7),true));
  println(absDif(a, pics.get(7),!true));
  image(minDif(a,pics), 0, 0);
}

void draw() {
}

long absDif(PImage a, PImage b, boolean reverse) {
  a.loadPixels();
  int[] aa = a.pixels;
  b.loadPixels();
  int[] bb = b.pixels;
  int[] cc = new int[aa.length];
  for (int i=0; i<aa.length; i++) {
    if (reverse) {
      cc[i] = abs(aa[i]-bb[bb.length-i-1]);
    } else {
      cc[i] = abs(aa[i]-bb[i]);
    }
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
  long dif = absDif(a, L.get(0),true);
  int ret = 0;
  long b;
  for (int i=0; i<L.size (); i++) {
    b = absDif(a, L.get(i), true);
    if (b<dif) {
      dif=b;
      ret=i;
      println(i);
    }
    b = absDif(a, L.get(i), false);
    if (b<dif) {
      dif=b;
      ret=i;
      println(i);
    }
  }
  println(dif);
  println(ret);
  return L.get(ret);
}

