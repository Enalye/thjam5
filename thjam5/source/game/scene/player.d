module game.scene.player;

import std.stdio;
import std.math, std.algorithm.comparison;
import atelier;
import game.scene.actor, game.scene.solid;

/// Player controlled actor.
final class Player: Actor {
    private {
        enum gravity = .9f;
        enum maxFall = -90f;

        enum jumpSpeed = 18f;

        enum maxRun = 5f;
        enum runAccel = 1f;
        enum runDeccel = .4f;
    }

    float approach(float value, float target, float step) {
        return value > target ? max(value - step, target) : min(value + step, target);
    }

    int sign(float value) {
        return value > 0f ? 1 : (value < 0f ? -1 : 0);
    }

    private {
        int _direction = 0;
        Vec2f _speed = Vec2f.zero;
        bool _onGround = false, _canDoubleJump = true;
        Solid _solidRiding;
    }

    /// Ctor
    this() {
        position = Vec2i(0, 0);
        hitbox = Vec2i(16, 32);
    }

    override void update(float deltaTime) {
        if(_solidRiding && _onGround) {
            if(!isRiding(_solidRiding))
                _onGround = false;
        }

        // Horizontal movement
        _direction = 0;
        if(isButtonDown(KeyButton.a)) {
            _direction --;
        }
        if(isButtonDown(KeyButton.d)) {
            _direction ++;
        }

        {
            float mult = _onGround ? 1f : .65f;
            if(abs(_speed.x) > maxRun && _direction == sign(_speed.x))
                _speed.x = approach(_speed.x, maxRun * _direction, runDeccel * mult);
            else
                _speed.x = approach(_speed.x, maxRun * _direction, runAccel * mult);
        }

        if(getButtonDown(KeyButton.space)) {
            jump();
        }

        if(!_onGround) {
            _speed.y = approach(_speed.y, maxFall, gravity * deltaTime);
        }

        moveX(_speed.x, &onHitWall);

        if(_speed.y < 0f)
            moveY(_speed.y, &onHitGround);
        else
            moveY(_speed.y, null);

    }

    /// We touch a wall left or right.
    void onHitWall(Solid solid) {

    }

    /// We touch a platform below us.
    void onHitGround(Solid solid) {
        _onGround = true;
        _canDoubleJump = true;
        _solidRiding = solid;
        _speed.y = 0f;
    }

    void jump() {
        if(_onGround) {
            _speed.y = jumpSpeed;
            _onGround = false;
        }
        else if(_canDoubleJump) {
            _canDoubleJump = false;
            _speed.y = jumpSpeed;
        }
    }

    override bool isRiding(Solid solid) {
        // Add edge cases (wall-grab, etc)
        return super.isRiding(solid);
    }

    override void draw() {
        drawFilledRect(getHitboxOrigin2d(), getHitboxSize2d(), Color.red);
    }

    override void squish(Solid solid) {
        // Squish means we got crushed between 2 solids.
        // We'll most likely respawn here.
        position = Vec2i(0, 0);
        writeln("squished");
    }
}