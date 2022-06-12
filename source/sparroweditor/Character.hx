package sparroweditor;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxSprite;

class Character extends FlxSprite
{
    public var idleAnim:String = null;

    public var animOffsets:Map<String, Array<Int>> = [];
    private var offsetX:Int = 0;
    private var offsetY:Int = 0;

    public var animList:Array<String> = [];
    public var curAnim:Int = 1;

    public function new(X:Float = 0, Y:Float = 0, Frames:FlxAtlasFrames):Void
    {
        super(X, Y);
        frames = Frames;
    }

    override function update(elapsed:Float):Void
    {
        if (FlxG.keys.pressed.SHIFT)
        {
            if (FlxG.keys.anyPressed([W, UP]))
                offsetY++;
			if (FlxG.keys.anyPressed([S, DOWN]))
                offsetY--;
			if (FlxG.keys.anyPressed([A, LEFT]))
				offsetX++;
			if (FlxG.keys.anyPressed([D, RIGHT]))
				offsetX--;
        }
        else
        {
			if (FlxG.keys.anyJustPressed([W, UP]))
				offsetY++;
			if (FlxG.keys.anyJustPressed([S, DOWN]))
				offsetY--;
			if (FlxG.keys.anyJustPressed([A, LEFT]))
				offsetX++;
			if (FlxG.keys.anyJustPressed([D, RIGHT]))
				offsetX--;
        }

        if (FlxG.keys.justPressed.SPACE)
        {
            if (curAnim >= animList.length)
                curAnim = 0;

            playAnim(animList[curAnim]);
			var offs:Array<Int> = animOffsets.get(animList[curAnim]);
			if (offs != null)
			{
                offsetX = offs[0];
                offsetY = offs[1];
            }
            curAnim++;
        }

		addOffset(animation.curAnim.name, offsetX, offsetY);
        offset.set(offsetX, offsetY);
        super.update(elapsed);
    }

    public function addOffset(anim:String, offX:Int, offY:Int):Void
    {
		animOffsets.set(anim, [offX, offY]);
    }

    public function addAnimations(animList:Array<String>, fps:Int)
    {
		this.animList = animList;

        for (anim in animList)
        {
            if (idleAnim == null)
                idleAnim = anim;
            animation.addByPrefix(anim, anim, fps);
            addOffset(anim, 0, 0);
        }
    }

	public function playAnim(?AnimName:String, ?Force:Bool = false, ?Reversed:Bool = false, ?Frame:Int = 0):Void
    {
        if (AnimName == null)
            AnimName = idleAnim;

		var offs:Array<Int> = animOffsets.get(AnimName);
        if (offs != null)
            offset.set(offs[0], offs[1]);
        else
            addOffset(AnimName, 0, 0);

        animation.play(AnimName, Force, Reversed, Frame);
    }
}