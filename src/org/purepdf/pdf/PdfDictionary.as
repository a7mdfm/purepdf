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
package org.purepdf.pdf
{
	import it.sephiroth.utils.HashMap;
	import it.sephiroth.utils.IObject;
	import it.sephiroth.utils.KeySet;
	import it.sephiroth.utils.ObjectHash;
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import org.purepdf.pdf.interfaces.IOutputStream;

	public class PdfDictionary extends PdfObject implements IObject
	{
		public static const PAGE: PdfName = PdfName.PAGE;
		public static const CATALOG: PdfName = PdfName.CATALOG;
		public static const OUTLINES: PdfName = PdfName.OUTLINES;
		
		protected var hashMap: HashMap;
		protected var dictionaryType: PdfName;
		
		public function PdfDictionary( $type: PdfName = null )
		{
			super( DICTIONARY );
			hashMap = new HashMap();
			
			if( $type != null )
			{
				dictionaryType = $type;
				put( PdfName.TYPE, dictionaryType );
			}
		}
		
		public function put( key: PdfName, object: PdfObject ): void
		{
			if( object == null || object.isNull() )
			{
				hashMap.remove( key );
			} else {
				hashMap.put( key, object );
			}
		}
		
		public function remove( key: PdfName ): void
		{
			hashMap.remove( key );
		}
		
		public function getKeys(): KeySet
		{
			return hashMap.keySet();
		}
		
		public function getValue( key: PdfName ): PdfObject
		{
			return hashMap.getValue( key ) as PdfObject;
		}
		
		public function size(): int
		{
			return hashMap.size();
		}
		
		public function mergeDifferent( other: PdfDictionary ): void
		{
			var i: Iterator = other.hashMap.keySet().iterator();
			for( i; i.hasNext(); )
			{
				var key: ObjectHash = i.next();
				if( !hashMap.containsKey( key ) )
					hashMap.put( key, other.hashMap.getValue( key ) );
			}
		}
		
		override public function toString(): String
		{
			if( getValue( PdfName.TYPE ) == null )
				return "Dictionary";
			return "Dictionary of type: " + getValue( PdfName.TYPE );
		}
		
		public function merge( other: PdfDictionary ): void
		{
			hashMap.putAll( other.hashMap );
		}
		
		public function putAll( other: PdfDictionary ): void
		{
			hashMap.putAll( other.hashMap );
		}
		
		public function contains( key: PdfName ): Boolean
		{
			return hashMap.containsKey(key);
		}
		
		public function getAsDict( key: PdfName ): PdfDictionary
		{
			var dict: PdfDictionary = null;
			var orig: PdfObject = getDirectObject( key );
			if( orig != null && orig.isDictionary() )
				dict = orig as PdfDictionary;
			return dict;
		}
		
		/**
		 * Returns the <CODE>PdfObject</CODE> associated to the specified
		 * <VAR>key</VAR>, resolving a possible indirect reference to a direct
		 * object.
		 * 
		 * This method will never return a <CODE>PdfIndirectReference</CODE>
		 * object.  
		 * 
		 */
		public function getDirectObject( key: PdfName ): PdfObject
		{
			return PdfReader.getPdfObject( getValue( key ) );
		}
		
		override public function toPdf( writer: PdfWriter, os: IOutputStream ) : void
		{			
			os.writeInt( '<'.charCodeAt(0) );
			os.writeInt( '<'.charCodeAt(0) );
			
			var value: PdfObject;
			var type: int = 0;
			
			var key: PdfName;
			var i: Iterator = hashMap.keySet().iterator();
			
			for( i; i.hasNext(); )
			{
				key = PdfName( i.next() );
				value = PdfObject( hashMap.getValue( key ) );
				
				key.toPdf( writer, os );
				type = value.getType();

				
				if( type != PdfObject.ARRAY && type != PdfObject.DICTIONARY && type != PdfObject.NAME && type != PdfObject.STRING )
					os.writeInt(' '.charCodeAt(0) );
				value.toPdf( writer, os );
			}
			
			os.writeInt( '>'.charCodeAt(0) );
			os.writeInt( '>'.charCodeAt(0) );
		}
	}
}