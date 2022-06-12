package sparroweditor.parser;

import sys.io.File;
import haxe.iterators.StringIterator;
import openfl.Assets;
#if haxe4
import haxe.xml.Access;
#else
import haxe.xml.Fast as Access;
#end

using StringTools;

class SparrowAnim
{
    /**
     * Returns a list of animation names from a Sparrow spritesheet's XMl.
     * @param xml The path to the XML file.
     * @return A `String` array containing names of the animations from the XML.
     */
    public static function getList(xml:String):Array<String>
    {
		//if (xml == null || !Assets.exists(xml, TEXT) || haxe.io.Path.extension(xml) != "xml")
		//    return null;

		var xmlData:Access = new Access(Xml.parse(File.getContent(xml)).firstElement());
		var rawNames:Array<String> = [];

		for (tex in xmlData.nodes.SubTexture)
		{
			rawNames.push(tex.att.name);
		}

		var finalNames:Array<String> = [];
		for (name in rawNames)
		{
			var stripName:String = cleanName(stripNum(name));
			if (!finalNames.contains(stripName))
				finalNames.push(stripName);
		}

        return finalNames;
    }

	// optimize?
	private static function stripNum(string:String):String
	{
		var nums:String = "1234567890";
		var iter:StringIterator = new StringIterator(string);
		var processedString:String = "";

		for (charCode in iter)
		{
			var char:String = String.fromCharCode(charCode);
			if (nums.contains(char))
				continue;

			processedString += char;
		}

		return processedString;
	}

	private static function cleanName(string:String):String
	{
		var str:String = string;
		if (str.contains("instance"))
			str.replace("instance", "");
		return str.trim();
	}
}