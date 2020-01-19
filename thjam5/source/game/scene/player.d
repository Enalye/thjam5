module game.scene.player;

import std.stdio;
import atelier;

import
game.scene.world,
game.scene.actor,
game.scene.solid,
game.scene.wall,
game.scene.haniwa;

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

        enum knockbackSpeed = 12f;
    }

    private {
        int _direction = 0, _facingWall = 0, _facing = 1;
        Vec2f _speed = Vec2f.zero;
        bool _onGround = false, _canDoubleJump = true;
        bool _isWallGrabbing = false;

        Solid       _solidRiding;
        Animation _currentAnimation;
        Animation _animationIdle;
        Animation _animationRun;
        Animation _animationJump;
        Sound     _hitSound;

        Timer _jumpTimer, _grabTimer, _invicibilityTimer;
    }

    int nbHaniwas = 3;

    HaniwaArray haniwas;

    /// Ctor
    this() {
        isPlayer = true;
        position = Vec2i(0, 30);
        hitbox = Vec2i(25, 38);

        haniwas = new HaniwaArray();

        _animationIdle = fetch!Animation("keiki.idle");
        _animationRun  = fetch!Animation("keiki.run");
        _animationJump = fetch!Animation("keiki.jump");
        _animationIdle.start();
        _animationRun.start();

        _hitSound         = fetch!Sound("hit");
        _currentAnimation = _animationIdle;
    }

    override void update(float deltaTime) {
        _jumpTimer.update(deltaTime);
        _grabTimer.update(deltaTime);
        _invicibilityTimer.update(deltaTime);
        
        if(position.y < -1000)
            position = Vec2i(position.x, 1000);

        if(_solidRiding && _onGround) {
            if(!isRiding(_solidRiding))
                _onGround = false;
        }

        // Horizontal movement
        _direction = 0;
        if(isButtonDown(KeyButton.left)) {
            _direction--;
            _facing = -1;
        }
        if(isButtonDown(KeyButton.right)) {
            _direction++;
            _facing = 1;
        }

        if(_direction != 0) {
            _currentAnimation = _animationRun;
        } else {
            _currentAnimation = _animationIdle;
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
                        _facingWall = _direction;
                    }
                    else {
                        _isWallGrabbing = false;
                    }
                }
            }
        }
        else {
            if(isButtonDown(KeyButton.z)) {
                Solid solid = collideAt(position + Vec2i(_facingWall, 0), Vec2i(hitbox.x, hitbox.y / 2));
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

        if((nbHaniwas > 0) && getButtonDown(KeyButton.x)) {
            Vec2i haniwaSpawnPos = Vec2i(position.x + _facing * 75, position.y);
            Haniwa haniwa = new Haniwa(haniwaSpawnPos, Vec2i(30, 16), _facing);
            haniwas.push(haniwa);
            --nbHaniwas;
            getRythmHandler().playDebugSound();
        }

        //-- Jump
        if(getButtonDown(KeyButton.c) && !_jumpTimer.isRunning) {
            if(_isWallGrabbing && _canDoubleJump)
                wallJump(deltaTime);
            else if(_onGround)
                jump(deltaTime);
            else if(_canDoubleJump)
                doubleJump(deltaTime);
        }

        if(_jumpTimer.isRunning) {
            _animationJump.start();
            _currentAnimation = _animationJump;
        }

        if(!_onGround && !_isWallGrabbing) {
            _speed.y = approach(_speed.y, maxFall, gravity * deltaTime);
        }

        moveX(_speed.x, &onHitWall);

        if(_speed.y < 0f)
            moveY(_speed.y, &onHitGround);
        else
            moveY(_speed.y, null);

        foreach(Haniwa haniwa, uint actorIdx; haniwas) {
            haniwa.update(deltaTime);
            if(haniwa.toDelete) {
                haniwas.markInternalForRemoval(actorIdx);
            }
        }
        haniwas.sweepMarkedData();

        _currentAnimation.update(deltaTime);


        if(currentHaniwas != haniwas.length) {
            currentHaniwas = haniwas.length;
            import game.gui;
            setBombsGui(3 - currentHaniwas);
        }
    }
    int currentHaniwas = 3;

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

    void wallJump(float deltaTime) {
        if(isButtonDown(KeyButton.up)) {
            if((isButtonDown(KeyButton.right) && _facingWall != 1) ||
                (isButtonDown(KeyButton.left) && _facingWall != -1))
                _speed += Vec2f(-_facingWall * wallJumpSpeed, wallJumpSpeed) * deltaTime;
            else
                _speed += Vec2f(0, wallJumpSpeed) * deltaTime;
        }
        else
            _speed += Vec2f(-_facingWall * wallJumpSpeed, wallJumpSpeed) * deltaTime;
        _isWallGrabbing = false;
        _onGround = false;
        _canDoubleJump = false;
        _jumpTimer.start(jumpTime);
        _grabTimer.start(grabTime);
    }

    void jump(float deltaTime) {
        _speed.y = jumpSpeed * deltaTime;
        _onGround = false;
        _jumpTimer.start(jumpTime);
    }

    void doubleJump(float deltaTime) {
        _canDoubleJump = false;
        _speed.y = doubleJumpSpeed * deltaTime;
        _jumpTimer.start(jumpTime);
    }

    void knockback() {
        if(_direction != 0)
            _speed += Vec2f(-_direction, 1) *  knockbackSpeed;
        else
            _speed += Vec2f.one *  knockbackSpeed;

        _isWallGrabbing = false;
        _canDoubleJump = false;
        _onGround = false;
        _jumpTimer.start(jumpTime);
    }

    override bool isRiding(Solid solid) {
        if(_isWallGrabbing)
            return solid == _solidRiding;
        return super.isRiding(solid);
    }

    override void draw() {
        if(_invicibilityTimer.isRunning) {
            _currentAnimation.color = Color(1f, 0.5f, 0.5f, 0.8f);
        } else {
            _currentAnimation.color = Color(1f, 1f, 1f, 1f);
        }

        foreach(Haniwa haniwa; haniwas) {
            haniwa.draw();
        }
        
        if(_facing == -1) {
            _currentAnimation.flip = Flip.horizontal;
        } else {
            _currentAnimation.flip = Flip.none;
        }
        
        _currentAnimation.draw(getPosition2d());
    }

    override void squish(CollisionData data) {
        hit();
    }

    int life = 5;
    void hit() {
        if(!_invicibilityTimer.isRunning) {
            _hitSound.play();
            _invicibilityTimer.start(1f);
            life --;
            knockback();
            import game.gui;
            setLifeGui(life);
            if(life < 0) {
                import game.menu;
                onMainMenu();
            }
        }
    }
}