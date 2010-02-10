/*
*                             ______ _____  _______ 
* .-----..--.--..----..-----.|   __ \     \|    ___|
* |  _  ||  |  ||   _||  -__||    __/  --  |    ___|
* |   __||_____||__|  |_____||___|  |_____/|___|    
* |__|
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
* The Original Code is 'iText, a free JAVA-PDF library' ( version 4.2 ) by Bruno Lowagie.
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
package org.purepdf.elements
{
	import org.purepdf.Font;

	public class ListItem extends Paragraph
	{
		protected var _symbol: Chunk;
		
		public function ListItem( text: String, font: Font=null )
		{
			super( text, font );
		}
		
		public function set listSymbol( value: Chunk ): void
		{
			if( _symbol == null )
			{
				_symbol = value;
				if( _symbol.font.isStandardFont )
					_symbol.font = font;
			}
		}
		
		public function get listSymbol(): Chunk
		{
			return _symbol;
		}
		
		public function setIndentationLeft( indentation: Number, autoindent: Boolean ): void
		{
			if( autoindent )
				indentationLeft = listSymbol.getWidthPoint();
			else
				indentationLeft = indentation;
		}
		
		
		public static function fromPhrase( phrase: Phrase ): ListItem
		{
			var result: ListItem = new ListItem( null );
			result.initFromPhrase( phrase );
			return result;
		}
		
		public static function fromChunk( chunk: Chunk ): ListItem
		{
			var result: ListItem = new ListItem( null );
			result.initFromChunk( chunk );
			return result;
		}
		
		override public function get type() : int
		{
			return Element.LISTITEM;
		}
	}
}