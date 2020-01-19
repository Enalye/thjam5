
module game.scene.background;

import atelier;

class Background {
    Sprite _background;
    Sprite _boss1;
    Sprite _boss2;

    this(string backgroundName, string boss1Name, string boss2Name) {
        _background = fetch!Sprite(backgroundName);
        _boss1      = fetch!Sprite(boss1Name);
        _boss2      = fetch!Sprite(boss2Name);
    }

    void draw() {
        //_background.size *= 1.75f;
        _background.draw(Vec2f.zero);
    }
}