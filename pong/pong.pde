// ボールがあるかの管理フラグ
boolean hasBall = false;
Ball ball;
// ユーザー操作のラケット
ReflectBoard userBoard = new ReflectBoard();
// 対戦相手のラケット
ReflectBoard aiBoard = new ReflectBoard();
// ボールをどちらにとばしているかのフラグ
boolean toUser = false;

void setup() {
    size(600, 400);
    background(255);

    userBoard.setX(590);
    aiBoard.setX(0);
}

void draw() {
    // ステージの描写
    background(255);
    fill(0, 0, 0);
    // 線の太さを設定
    strokeWeight(2);
    // 線を描写
    line(0, 9, 600, 9);
    line(0, 391, 600, 391);

    // ボールオブジェクトの有無により条件分岐
    if(!hasBall) {
        // ボールオブジェクトを生成
        ball = new Ball();
        hasBall = true;
    }

    // spaceキーが押されたら
    if(keyPressed && key == ' ' && ball.vx == 0 && ball.vy == 0) {
        // ボールのスタート関数を呼び出す
        ball.start();
    }

    // ボールの描写
    // 位置情報の更新
    ball.move();

    fill(0, 0, 0);
    ellipse(ball.x, ball.y, ball.diameter, ball.diameter);

    // ボールが範囲外に出た場合の処理
    if(ball.y < 20 || ball.y > 380) {
        ball.verticalReflect();
    }
    if(ball.x < -10 || ball.x > 610) {
        ball = new Ball();
    }

    // ラケットの描写
    fill(0, 0, 0);
    rect(userBoard.x, userBoard.y, 10, 100);
    rect(aiBoard.x, aiBoard.y, 10, 100);

    // ラケットの操作
    if(keyPressed) {
        if(key == 'u' && userBoard.y > 10) {
            userBoard.moveUp();
        }else if(key == 'j' && userBoard.y < 290) {
            userBoard.moveDown();
        }
    }

    // ai のラケット操作
    if(!toUser && ball.x < 400) {
        if(ball.y < aiBoard.y + 35 && aiBoard.y > 10) {
            aiBoard.moveUp();
        }else if(ball.y > aiBoard.y + 65 && aiBoard.y < 300) {
            aiBoard.moveDown();
        }
    }

    // ball とラケットの当たり判定
    if(ball.x < 20 && ball.y > aiBoard.y && ball.y < aiBoard.y + 100 && !toUser) {
        ball.horizontalReflect();
        toUser = true;
    }
    if(ball.x > 580 && ball.y > userBoard.y && ball.y < userBoard.y + 100 && toUser) {
        ball.horizontalReflect();
        toUser = false;
    }
}

// ball class
class Ball {
    // ボールの位置
    float x = 300;
    float y = 200;
    // ボールの速度
    float vx = 0;
    float vy = 0;
    // ボールの大きさ
    float diameter = 20;

    // スタート時の初期設定関数
    void start() {
        while (-5 < vx && vx < 5) {
            vx = random( -5, 6);    
        }
        while (-4 < vy && vy < 4) {
            vy = random( -6, 7);
        }
        if(vx > 0) {
            toUser = true;
        }else{
            toUser = false;
        }
    }

    // ボールの反射関数
    // 上下
    void verticalReflect() {
        vy = -vy;
    }
    // 左右
    void horizontalReflect() {
        vx = -vx;
        // ラケットの方向によってvyを変更
        // 変化の大きさを保持する変数
        int changevy = 2;
        if(toUser) {
            if(keyPressed && key == 'u') {
                vy -= changevy;
            }else if(keyPressed && key == 'j') {
                vy += changevy;
            }
        }else{
            if(ball.y < aiBoard.y + 35) {
                vy -= changevy;
            }else if(ball.y > aiBoard.y + 65) {
                vy += changevy;
            }
        }
    }

    // 移動関数
    void move() {
        x += vx;
        y += vy;
    }
}

// 反射板のクラス
class ReflectBoard {
    float x = 0;
    float y = 150;

    // x 座標をセット
    void setX(float x) {
        this.x = x;
    }

    // 上移動
    void moveUp() {
        y -= 5;
    }

    // 下移動
    void moveDown() {
        y += 5;
    }
}