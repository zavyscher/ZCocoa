package com.core.utils
{
	import com.adobe.serialization.json.JSONDecoder;
	
	import flash.utils.Dictionary;
	
	// For this extension of dictionary, we serialize the contents of the 
	// dictionary by using toJSON
	public final class JSONDict
	{
		public static function encode(o: Object): String
		{
			return convertToString(o);
		}
		
		private static function convertToString( value:* ):String
		{
			// determine what value is and convert it based on it's type
			if ( value is String )
			{
				// escape the string so it's formatted correctly
				return escapeString( value as String );
			}
			else if ( value is Number )
			{
				// only encode numbers that finate
				return isFinite( value as Number ) ? value.toString() : "null";
			}
			else if ( value is Boolean )
			{
				// convert boolean to string easily
				return value ? "true" : "false";
			}
			else if ( value is Array )
			{
				// call the helper method to convert an array
				return arrayToString( value as Array );
			}
			else if ( value != null && value is Dictionary )
			{
				// call the helper method to convert an Dictionary
				return dictionaryToString( value );
			}
			else if ( value != null && value is Object)
			{
				// call the helper method to convert an object
				return objectToString( value as Object );
			}
			
			return "null";
		}
		
		/**
		 * Escapes a string accoding to the JSON specification.
		 *
		 * @param str The string to be escaped
		 * @return The string with escaped special characters
		 * 		according to the JSON specification
		 */
		private static function escapeString( str:String ):String
		{
			// create a string to store the string's jsonstring value
			var s:String = "";
			// current character in the string we're processing
			var ch:String;
			// store the length in a local variable to reduce lookups
			var len:Number = str.length;
			
			// loop over all of the characters in the string
			for ( var i:int = 0; i < len; i++ )
			{
				// examine the character to determine if we have to escape it
				ch = str.charAt( i );
				switch ( ch )
				{
					case '"': // quotation mark
						s += "\\\"";
						break;
					
					//case '/':	// solidus
					//	s += "\\/";
					//	break;
					
					case '\\': // reverse solidus
						s += "\\\\";
						break;
					
					case '\b': // bell
						s += "\\b";
						break;
					
					case '\f': // form feed
						s += "\\f";
						break;
					
					case '\n': // newline
						s += "\\n";
						break;
					
					case '\r': // carriage return
						s += "\\r";
						break;
					
					case '\t': // horizontal tab
						s += "\\t";
						break;
					
					default: // everything else
						
						// check for a control character and escape as unicode
						if ( ch < ' ' )
						{
							// get the hex digit(s) of the character (either 1 or 2 digits)
							var hexCode:String = ch.charCodeAt( 0 ).toString( 16 );
							
							// ensure that there are 4 digits by adjusting
							// the # of zeros accordingly.
							var zeroPad:String = hexCode.length == 2 ? "00" : "000";
							
							// create the unicode escape sequence with 4 hex digits
							s += "\\u" + zeroPad + hexCode;
						}
						else
						{
							
							// no need to do any special encoding, just pass-through
							s += ch;
							
						}
				} // end switch
				
			} // end for loop
			
			return "\"" + s + "\"";
		}
		
		/**
		 * Converts an array to it's JSON string equivalent
		 *
		 * @param a The array to convert
		 * @return The JSON string representation of <code>a</code>
		 */
		private static function arrayToString( arr:Array ):String
		{
			// create a string to store the array's jsonstring value
			var s:String = "";
			
			// loop over the elements in the array and add their converted
			// values to the string
			var length:int = arr.length;
			for ( var i:int = 0; i < length; i++ )
			{
				// when the length is 0 we're adding the first element so
				// no comma is necessary
				if ( s.length > 0 )
				{
					// we've already added an element, so add the comma separator
					s += ",";
				}
				
				// convert the value to a string
				s += convertToString( arr[ i ] );
			}
			
			// KNOWN ISSUE:  In ActionScript, Arrays can also be associative
			// objects and you can put anything in them, ie:
			//		myArray["foo"] = "bar";
			//
			// These properties aren't picked up in the for loop above because
			// the properties don't correspond to indexes.  However, we're
			// sort of out luck because the JSON specification doesn't allow
			// these types of array properties.
			//
			// So, if the array was also used as an associative object, there
			// may be some values in the array that don't get properly encoded.
			//
			// A possible solution is to instead encode the Array as an Object
			// but then it won't get decoded correctly (and won't be an
			// Array instance)
			
			// close the array and return it's string value
			return "[" + s + "]";
		}
		
		private static function dictionaryToString(dict: Dictionary): String
		{
			var resultStr: String = "";
			for (var index: String in dict)
			{
				resultStr += (resultStr != "") ? "," : "";
				var subVal: String = convertToString(dict[index]);
				resultStr += "\"" + index + "\":" + subVal;
			}
			return "{" + resultStr + "}";
		}
		
		private static function objectToString(obj: Object): String
		{
			var resultStr: String = "";
			for (var index: String in obj)
			{
				resultStr += (resultStr != "") ? "," : "";
				var subVal: String = convertToString(obj[index]);
				resultStr += "\"" + index + "\":" + subVal;
			}
			return "{" + resultStr + "}";
		}
		
		public static function decode( s:String, strict:Boolean = true ):*
		{
			return new JSONDecoder( s, strict ).getValue();
		}
		//
	}
}



