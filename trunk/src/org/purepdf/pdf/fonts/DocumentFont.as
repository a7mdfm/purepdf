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
package org.purepdf.pdf.fonts
{
	import flash.utils.Dictionary;
	
	import it.sephiroth.utils.HashMap;
	
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.pdf.PRIndirectReference;
	import org.purepdf.pdf.PdfDictionary;
	import org.purepdf.pdf.PdfIndirectReference;

	public class DocumentFont extends BaseFont
	{
		private var metrics: HashMap = new HashMap();
		private var fontName: String;
		private var _refFont: PRIndirectReference;
		private var font: PdfDictionary;
		private var uni2byte: Dictionary = new Dictionary();
		private var diffmap: Dictionary;
		private var Ascender: Number = 800;
		private var CapHeight: Number = 700;
		private var Descender: Number = -200;
		private var ItalicAngle: Number = 0;
		private var llx: Number = -50;
		private var lly: Number = -200;
		private var urx: Number = 100;
		private var ury: Number = 900;
		private var isType0: Boolean = false;
		private var cjkMirror: BaseFont;
		
		
		public function DocumentFont()
		{
			super();
			throw new NonImplementatioError();
		}
		
		public function get indirectReference(): PdfIndirectReference
		{
			return _refFont;
		}
	}
}