void setup() {
    size(800, 800);
    background(255);

    colorMode(HSB, 360, 100, 100);
    noStroke();
}

int c = 0;
boolean a = true;

void draw() {
    boolean b = a;
    int c2 = c;
    for(int i = 0; i < 100; i++) {
        // x を基準とした描写
        if(c == 0) { a = true; }
        if(c == 100) { a = false; }

        if(b) {
            c++;
            fill(30, c2, 100);
            if(c2 == 100) { b = false; }
        }else{
            c--;
            fill(30, c2, 100);
            if(c2 == 0) { b = true; }
        }
        rect(i * 8, 0, 8, height);
    }

    if(a) {
        c++;
    } else {
        c--;
    }
}