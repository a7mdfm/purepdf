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
package org.purepdf.utils
{
	import flash.utils.ByteArray;
	
	import it.sephiroth.utils.HashMap;
	import it.sephiroth.utils.KeySet;
	
	import org.purepdf.io.LineReader;

	public class Properties implements IProperties
	{
		private var map: HashMap;

		public function Properties()
		{
			map = new HashMap();
		}

		public function getProperty( name: String ): String
		{
			return map.getValue( name ) as String;
		}
		
		public function hasProperty( name: String ): Boolean
		{
			return map.containsKey( name );
		}

		public function get keys(): KeySet
		{
			return map.keySet();
		}

		public function load( b: ByteArray ): void
		{
			var lr: LineReader = new LineReader( b );
			var line: String;
			var tok: StringTokenizer;

			while ( ( line = lr.readLine() ) != null )
			{
				tok = new StringTokenizer( line, /=/g );

				if ( tok.hasMoreTokens() )
				{
					var key: String = tok.nextToken();
					var value: String = tok.nextToken();
					if( value && value.length > 0 )
						map.put( key, value );
				}
			}
		}

		public function remove( name: String ): void
		{
			map.remove( name );
		}
	}
}