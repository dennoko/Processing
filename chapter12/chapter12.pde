// シューティングゲーム

Player player = new Player();
// 弾のリスト
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
// 敵のリスト
ArrayList<Enemy> enemies = new ArrayList<Enemy>();

void setup() {
    size(800, 800);
    // 敵を三体ランダムな位置に生成
    for(int i = 0; i < 3; i++) {
        int x = int(random(800));
        int y = int(random(800));
        Enemy e = new Enemy(x, y);
        enemies.add(e);
    }
    frameRate(30);
}

boolean isStart = false;

void draw() {
    background(60);

    // スペースを押すまでゲームを開始しない
    while (!isStart) {
        fill(255);
        textSize(50);
        text("Press Space to Start", 200, 400);
        if (keyPressed && key == ' ') {
            isStart = true;
        }
        return;
    }

    // プレイヤーの描画
    fill(255);
    ellipse(player.x, player.y, 20, 20);
    player.move();
    // プレイヤーの体力ゲージを描画
    fill(255);
    rect(player.x - 10, player.y - 20, 20, 5);
    fill(0, 255, 0);
    rect(player.x - 10, player.y - 20, player.hp/4, 5);

    // 弾の描画
    for(int i = 0; i < bullets.size(); i++) {
        Bullet b = bullets.get(i);
        if(b.isPlayerBullet)
            fill(0, 0, 255);
        else
            fill(255, 0, 0);
        ellipse(b.x, b.y, 10, 10);
        b.move();
        // 画面外に出たら削除
        if(b.x < 0 || b.x > 800 || b.y < 0 || b.y > 800) {
            bullets.remove(i);
        }
    }

    // 5フレームに1回弾を発射
    if(frameCount % 5 == 0) {
        player.shoot();
    }

    // 敵の描画
    for(int i = 0; i < enemies.size(); i++) {
        Enemy e = enemies.get(i);
        fill(255, 0, 0);
        ellipse(e.x, e.y, 20, 20);
        // 10 フレームに1回攻撃
        if(frameCount % 10 == 0) {
            e.attack();
        }

        // 体力ゲージを描画
        fill(255);
        rect(e.x - 10, e.y - 20, 20, 5);
        fill(0, 255, 0);
        rect(e.x - 10, e.y - 20, e.hp / 25, 5);
    }

    // プレイヤーと敵の弾の当たり判定
    for(int i = 0; i < bullets.size(); i++) {
        Bullet b = bullets.get(i);
        if(!b.isPlayerBullet) {
            float dx = player.x - b.x;
            float dy = player.y - b.y;
            float length = sqrt(dx*dx + dy*dy);
            if(length < 15) {
                player.hp--;
                bullets.remove(i);
            }
        }
    }
    // プレイヤーの弾と敵の当たり判定
    for(int i = 0; i < bullets.size(); i++) {
        Bullet b = bullets.get(i);
        if(b.isPlayerBullet) {
            for(int j = 0; j < enemies.size(); j++) {
                Enemy e = enemies.get(j);
                float dx = e.x - b.x;
                float dy = e.y - b.y;
                float length = sqrt(dx*dx + dy*dy);
                if(length < 15) {
                    e.damage();
                    bullets.remove(i);
                }
            }
        }
    }

    // ゲームオーバーまたはクリア
    if(player.hp <= 0) {
        fill(255);
        textSize(50);
        text("Game Over", 300, 400);
        noLoop();
    } else if(enemies.size() == 0) {
        fill(255);
        textSize(50);
        text("Clear", 350, 400);
        noLoop();
    }
}

class Player {
    // プレイヤーの位置
    int x = 400;
    int y = 700;
    // 移動速度
    private int speed = 5;
    // HP
    int hp = 80;

    // 移動
    void move() {
        if(keyPressed) {
            // wasdで移動
            if(key == 'w' && y > 0) {
                y -= speed;
            }
            if(key == 'a' && x > 0) {
                x -= speed;
            }
            if(key == 's' && y < 800) {
                y += speed;
            }
            if(key == 'd' && x < 800) {
                x += speed;
            }
        }
    }

    // mouseX, mouseYの方向に弾を発射
    void shoot() {
        // プレイヤーの位置からマウスの位置へのベクトルを計算
        float dx = mouseX - x;
        float dy = mouseY - y;
        // ベクトルを正規化
        float length = sqrt(dx*dx + dy*dy);
        dx /= length * 1.5;
        dy /= length * 1.5;
        // 弾を生成
        Bullet b = new Bullet(x, y, dx, dy);
        // 弾をリストに追加
        bullets.add(b);
    }
}

// 弾のクラス
class Bullet {
    int x, y;
    float vx, vy;
    // Playerからの弾かどうか
    boolean isPlayerBullet = true;
    // プレイヤーの弾には有効範囲を設定し、それを超えたら消滅
    int initx;
    int inity;
    int range = 500;

    // コンストラクタ
    Bullet(int x, int y, float vx, float vy) {
        this.x = x;
        this.y = y;
        this.vx = vx;
        this.vy = vy;
        initx = x;
        inity = y;
    }

    // 弾の移動
    void move() {
        x += vx * 10;
        y += vy * 10;
        if(isPlayerBullet) {
            float dx = x - initx;
            float dy = y - inity;
            float length = sqrt(dx*dx + dy*dy);
            if(length > range) {
                bullets.remove(this);
            }
        }
    }
}

// 敵のクラス
class Enemy {
    int x, y;
    // HP
    int hp = 500;

    // コンストラクタ
    Enemy(int x, int y) {
        this.x = x;
        this.y = y;
    }

    // 敵の攻撃
    // 1. 円形に24個の弾を発射
    void attack1() {
        for(int i = 0; i < 24; i++) {
            float dx = cos(radians(i * 15));
            float dy = sin(radians(i * 15));
            // 速度を1/5にする
            dx /= 2.0;
            dy /= 2.0;
            Bullet b = new Bullet(x, y, dx, dy);
            b.isPlayerBullet = false;
            bullets.add(b);
        }
    }

    // 2. プレイヤーの方向に弾を5個発射
    void attack2() {
        float dx = player.x - x;
        float dy = player.y - y;
        dx /= 8;
        dy /= 8;
        float length = sqrt(dx*dx + dy*dy);
        dx /= length;
        dy /= length;
        for(int i = 0; i < 5; i++) {
            Bullet b = new Bullet(x, y, dx, dy);
            b.isPlayerBullet = false;
            bullets.add(b);
        }
    }

    // ランダムで攻撃を選択
    void attack() {
        int r = int(random(8));
        if(r == 0 || r == 1) {
            attack1();
        } else if(r == 2 || r == 3) {
            attack2();
        }
    }

    // ダメージを受けた時
    void damage() {
        hp -= 10;
        if(hp <= 0) {
            enemies.remove(this);
        }
    }
}
