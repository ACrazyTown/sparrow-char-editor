package sparroweditor;

import sys.io.File;
import sparroweditor.parser.SparrowAnim;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;

using StringTools;

class EditorState extends FlxState
{
    private var defaultFPS:Int = 24;

    var gridBG:FlxSprite;
    var character:Character = null;

    override function create():Void
    {
        gridBG = FlxGridOverlay.create(10, 10, FlxG.width, FlxG.height);
        add(gridBG);

		FlxG.stage.window.onDropFile.add(function(path:String)
        {
            if (character != null)
            {
                character.destroy();
                remove(character);
            }

            var xmlPath:String = path.replace(".png", ".xml");
            var graphic:FlxGraphic = FlxGraphic.fromBitmapData(BitmapData.fromFile(path));

            character = new Character(125, 0, FlxAtlasFrames.fromSparrow(graphic, File.getContent(xmlPath)));
            character.screenCenter(Y);
            character.addAnimations(SparrowAnim.getList(xmlPath), defaultFPS);
            character.playAnim();
            add(character);
        });

        super.create();
    }

    override function update(elapsed:Float):Void
    {
		if (FlxG.mouse.wheel != 0)
			FlxG.camera.zoom += (FlxG.mouse.wheel / 10);

        super.update(elapsed);
    }
}