// 変数
int rowSize = 8;
int columnSize = 16;
int[][] fieldArray;

void setup() {
    size(500, 1000);
    background(255, 255, 255);
    // 
    fieldArray = new int[rowSize][columnSize];

    line(99, 99, 99, 801);
    line(401, 99, 401, 801);
    line(99, 801, 401, 801);
}

void draw() {

}

// 以下、クラス
//

// ブロック
class TBlock {
    int[][] block = {{0,1,0},{1,1,1},{0,0,0}};
}

// 以下、メソッド
// fieldにブロックを置く
drawBlock(int )
