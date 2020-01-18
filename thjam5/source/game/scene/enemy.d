module game.scene.enemy;

import std.stdio;
import std.math, std.algorithm.comparison;
import atelier;
import game.scene.world, game.scene.actor, game.scene.solid;

alias EnemyArray = IndexedArray!(Enemy, 5000u);

final class Enemy: Actor {
    private {
        enum gravity  = .9f;
        enum maxFall  = -16f;
        enum maxRun   = 5f;
        enum runAccel = 1f;
        enum runDeccel = .4f;

        int _direction = 0;

        Solid _solidRiding = null;
        bool  _onGround    = false;
    }

    public {
        Vec2f speed    = Vec2f.zero;
        bool  toDelete = false;
    }

    // So far name unused
    this(string name, Vec2i pos) {
        position = pos;
        hitbox   = Vec2i(10, 16);
    }

    override void update(float deltaTime) {
        if(_solidRiding && _onGround) {
            if(!isRiding(_solidRiding)) {
                _onGround = false;
            }
        }

        writeln(_onGround);

        slowDown(deltaTime);
        moveX(speed.x, &onHitWall);

        if(speed.y < 0f)
            moveY(speed.y, &onHitGround);
        else
            moveY(speed.y, null);
    }

    override bool isRiding(Solid solid) {
        return super.isRiding(solid);
    }

    override void draw() {
        drawFilledRect(getHitboxOrigin2d(), getHitboxSize2d(), Color.red);
    }

    override void squish(CollisionData data) {
        toDelete = true;
    }

    void onHitWall(CollisionData data) {

    }

    void onHitGround(CollisionData data) {
        _onGround    = true;
        _solidRiding = data.solid;
    }

    void slowDown(float deltaTime) {
        const float mult = _onGround ? 1f : .65f;
        if(abs(speed.x) > maxRun && _direction == sign(speed.x))
            speed.x = approach(speed.x, maxRun * _direction, runDeccel * mult);
        else
            speed.x = approach(speed.x, maxRun * _direction, runAccel * mult);

        if(!_onGround) {
            speed.y = approach(speed.y, maxFall, gravity * deltaTime);
        }
    }

    void jump(Vec2f jumpSpeed, float angle) {
        speed.x   = cos(jumpSpeed.x * (PI / 180)) * angle;
        speed.y   = sin(jumpSpeed.y * (PI / 180)) * angle;
        _onGround = false;
    }
}