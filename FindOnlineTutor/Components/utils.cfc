/**
 * utils
 *
 * @author rajendra mishra
 * @date 3/19/20
 **/
component  output="false"
{
	public string function generateCaptcha(numeric numChars="5")
	 output="false"
	{
		var local.aChars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
		var local.maxNum = ArrayLen(local.aChars);
		var local.toReturn = '';

		for(var i=1; i <= arguments.numChars; i++)
		{
			var local.randNum = randRange(1, local.maxNum);
			var local.letter = local.aChars[local.randNum];
			local.toReturn = local.toReturn&local.letter;
		}

		return toReturn;
	}

}