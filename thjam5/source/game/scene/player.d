module game.scene.player;

import std.stdio;
import std.math, std.algorithm.comparison;
import atelier;
import game.scene.world, game.scene.actor, game.scene.solid;

/// Player controlled actor.
final class Player: Actor {
    private {
        enum gravity = .9f;
        enum maxFall = -16f;

        enum jumpSpeed = 17f;
        enum doubleJumpSpeed = 14f;
        enum wallJumpSpeed = 14f;
        enum jumpTime = .2f;

        enum maxRun = 5f;
        enum runAccel = 1f;
        enum runDeccel = .4f;

        enum grabTime = .2f;
    }

    float approach(float value, float target, float step) {
        return value > target ? max(value - step, target) : min(value + step, target);
    }

    int sign(float value) {
        return value > 0f ? 1 : (value < 0f ? -1 : 0);
    }

    private {
        int _direction = 0, _facing = 0;
        Vec2f _speed = Vec2f.zero;
        bool _onGround = false, _canDoubleJump = true;
        bool _isWallGrabbing = false;
        Solid _solidRiding;

        Timer _jumpTimer, _grabTimer;
    }

    /// Ctor
    this() {
        position = Vec2i(0, 20);
        hitbox = Vec2i(10, 16);
    }

    override void update(float deltaTime) {
        _jumpTimer.update(deltaTime);
        _grabTimer.update(deltaTime);
        
        if(position.y < -1000)
            position = Vec2i(position.x, 1000);

        if(_solidRiding && _onGround) {
            if(!isRiding(_solidRiding))
                _onGround = false;
        }

        // Horizontal movement
        _direction = 0;
        if(isButtonDown(KeyButton.left)) {
            _direction --;
        }
        if(isButtonDown(KeyButton.right)) {
            _direction ++;
        }

        if(!_isWallGrabbing) {
            float mult = _onGround ? 1f : .65f;
            if(abs(_speed.x) > maxRun && _direction == sign(_speed.x))
                _speed.x = approach(_speed.x, maxRun * _direction, runDeccel * mult);
            else
                _speed.x = approach(_speed.x, maxRun * _direction, runAccel * mult);
        }

        //-- Wall grab
        if(!_isWallGrabbing) {
            if(!_grabTimer.isRunning) {
                if(isButtonDown(KeyButton.z)) {
                    Solid solid = collideAt(position + Vec2i(_direction, 0), Vec2i(hitbox.x, hitbox.y / 2));
                    if(solid) {
                        _solidRiding = solid;
                        _isWallGrabbing = true;
                        _speed.y = 0f;
                        _facing = _direction;
                    }
                    else {
                        _isWallGrabbing = false;
                    }
                }
            }
        }
        else {
            if(isButtonDown(KeyButton.z)) {
                Solid solid = collideAt(position + Vec2i(_facing, 0), Vec2i(hitbox.x, hitbox.y / 2));
                if(solid) {
                    _solidRiding = solid;
                    _isWallGrabbing = true;
                    _speed.y = 0f;
                }
                else {
                    _isWallGrabbing = false;
                }
            }
            else {
                _grabTimer.start(grabTime);
                _isWallGrabbing = false;
            }
        }

        //-- Jump
        if(getButtonDown(KeyButton.c) && !_jumpTimer.isRunning) {
            if(_isWallGrabbing && _canDoubleJump)
                wallJump();
            else if(_onGround)
                jump();
            else if(_canDoubleJump)
                doubleJump();
        }

        if(!_onGround && !_isWallGrabbing) {
            _speed.y = approach(_speed.y, maxFall, gravity * deltaTime);
        }

        moveX(_speed.x, &onHitWall);

        if(_speed.y < 0f)
            moveY(_speed.y, &onHitGround);
        else
            moveY(_speed.y, null);
    }

    /// We touch a wall left or right.
    void onHitWall(CollisionData data) {

    }

    /// We touch a platform below us.
    void onHitGround(CollisionData data) {
        _onGround = true;
        _canDoubleJump = true;
        _solidRiding = data.solid;
        _speed.y = 0f;
    }

    void wallJump() {
        if(isButtonDown(KeyButton.up)) {
            if((isButtonDown(KeyButton.right) && _facing != 1) ||
                (isButtonDown(KeyButton.left) && _facing != -1))
                _speed += Vec2f(-_facing * wallJumpSpeed, wallJumpSpeed);
            else
                _speed += Vec2f(0, wallJumpSpeed);
        }
        else
            _speed += Vec2f(-_facing * wallJumpSpeed, wallJumpSpeed);
        _isWallGrabbing = false;
        _onGround = false;
        _canDoubleJump = false;
        _jumpTimer.start(jumpTime);
        _grabTimer.start(grabTime);
    }

    void jump() {
        _speed.y = jumpSpeed;
        _onGround = false;
        _jumpTimer.start(jumpTime);
    }

    void doubleJump() {
        _canDoubleJump = false;
        _speed.y = doubleJumpSpeed;
        _jumpTimer.start(jumpTime);
    }

    override bool isRiding(Solid solid) {
        if(_isWallGrabbing)
            return solid == _solidRiding;
        return super.isRiding(solid);
    }

    override void draw() {
        drawFilledRect(getHitboxOrigin2d(), getHitboxSize2d(), Color.red);
    }

    override void squish(CollisionData data) {
        // Squish means we got crushed between 2 solids.
        // We'll most likely respawn here.
        position = Vec2i(0, 1000);
        writeln("squished");
    }
}