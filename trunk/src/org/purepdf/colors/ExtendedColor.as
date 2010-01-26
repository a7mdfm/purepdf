/*
* $Id$
* $Author Alessandro Crugnola $
* $Rev$ $LastChangedDate$
* $URL$
*
* The contents of this file are subject to  LGPL license 
* (the "GNU LIBRARY GENERAL PUBLIC LICENSE"), in which case the
* provisions of LGPL are applicable instead of those above.  If you wish to
* allow use of your version of this file only under the terms of the LGPL
* License and not to allow others to use your version of this file under
* the MPL, indicate your decision by deleting the provisions above and
* replace them with the notice and other provisions required by the LGPL.
* If you do not delete the provisions above, a recipient may use your version
* of this file under either the MPL or the GNU LIBRARY GENERAL PUBLIC LICENSE
*
* Software distributed under the License is distributed on an "AS IS" basis,
* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
* for the specific language governing rights and limitations under the License.
*
* The Original Code is 'iText, a free JAVA-PDF library' by Bruno Lowagie.
* All the Actionscript ported code and all the modifications to the
* original java library are written by Alessandro Crugnola (alessandro@sephiroth.it)
*
* This library is free software; you can redistribute it and/or modify it
* under the terms of the MPL as stated above or under the terms of the GNU
* Library General Public License as published by the Free Software Foundation;
* either version 2 of the License, or any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU LIBRARY GENERAL PUBLIC LICENSE for more
* details
*
* If you didn't download this code from the following link, you should check if
* you aren't using an obsolete version:
* http://code.google.com/p/purepdf
*
*/
package org.purepdf.colors
{

	public class ExtendedColor extends RGBColor
	{
		public static const TYPE_CMYK: int = 2;
		public static const TYPE_GRAY: int = 1;
		public static const TYPE_PATTERN: int = 4;
		public static const TYPE_RGB: int = 0;
		public static const TYPE_SEPARATION: int = 3;
		public static const TYPE_SHADING: int = 5;
		protected var _type: int;

		public function ExtendedColor( $type: int )
		{
			super( 0, 0, 0 );
			_type = $type;
		}

		public function get type(): int
		{
			return _type;
		}

		public static function getType( color: RGBColor ): int
		{
			if ( color is ExtendedColor )
				return ExtendedColor( color ).type;
			return TYPE_RGB;
		}

		public static function normalize( value: Number ): Number
		{
			if ( value < 0 )
				return 0;

			if ( value > 1 )
				return 1;
			return value;
		}
	}
}