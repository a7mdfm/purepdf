package org.purepdf.elements
{
	import org.purepdf.Font;
	import org.purepdf.elements.images.ImageElement;

	/**
	 * A Paragraph contains a series of Chunks and/or Phrases.
	 * A Paragraph has the same qualities of a Phrase, but also
	 * some additional layout-parameters:
	 * <ul>
	 * <li>the indentation</li>
	 * <li>the alignment of the text</li>
	 * </ul>
	 * <br />
	 * 
	 * Example:
	 * <pre>
	 * var p1: Paragraph = new Paragraph("This is a paragraph");
	 * 
	 * FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA, BuiltinFonts.HELVETICA );
	 * var p2: Paragraph = new Paragraph("This is a paragraph", new Font( Font.HELVETICA, 12, Font.NORMAL ) );
	 * </pre>
	 *
	 * @see		org.purepdf.elements.IElement
	 * @see		Phrase
	 * @see		org.purepdf.Font
	 * @see		org.purepdf.pdf.fonts.BuiltinFonts
	 * @see		org.purepdf.pdf.fonts.FontsResourceFactory
	 */
	public class Paragraph extends Phrase
	{
		protected var _alignment: int = Element.ALIGN_UNDEFINED;
		protected var _indentationLeft: Number = 0;
		protected var _indentationRight: Number = 0;
		protected var _keeptogether: Boolean = false;
		protected var _multipliedLeading: Number = 0;
		protected var _spacingAfter: Number = 0;
		protected var _spacingBefore: Number = 0;
		private var _extraParagraphSpace: Number = 0;
		private var _firstLineIndent: Number = 0;

		public function Paragraph( text: String, font: Font = null )
		{
			super( text, font );
		}
		
		/**
		 * Creates a new Paragraph from a starting Phrase/Paragraph
		 * 
		 * @return Paragraph
		 * @see Phrase
		 */
		public static function fromPhrase( phrase: Phrase = null ): Paragraph
		{
			var result: Paragraph = new Paragraph( null );
			result.initFromPhrase( phrase );
			
			if( phrase is Paragraph )
			{
				var p: Paragraph = Paragraph( phrase );
				result._alignment = p.alignment;
				result.setLeading( phrase.leading, p.multipliedLeading );
				result._indentationLeft = p.indentationLeft;
				result._indentationRight = p.indentationRight;
				result._firstLineIndent = p.firstLineIndent;
				result._spacingAfter = p.spacingAfter;
				result._spacingBefore = p.spacingBefore;
				result._extraParagraphSpace = p.extraParagraphSpace;
			}
			return result;
		}
		
		/**
		 * Create a new paragraph from a starting Chunk and leading
		 */
		public static function fromChunk( chunk: Chunk, leading: Number ): Paragraph
		{
			var p: Paragraph = new Paragraph( null, null );
			p.leading = leading;
			p.push( chunk );
			p.font = chunk.font;
			return p;
		}
		
		override public function add(o:Object) : Boolean
		{
			if (o is List) 
			{
				var list: List = List(o);
				list.indentationLeft =  list.indentationLeft + indentationLeft;
				list.indentationRight = indentationRight;
				return super.add(list);
			}
			else if (o is ImageElement ) {
				super.addSpecial(o);
				return true;
			}
			else if (o is Paragraph) {
				super.add(o);
				var chunks: Vector.<Object> = getChunks();
				if (!(chunks.length == 0)) {
					var tmp: Chunk = Chunk(chunks[chunks.length - 1]);
					super.add( new Chunk("\n", tmp.font) );
				}
				else {
					super.add( Chunk.NEWLINE );
				}
				return true;
			}
			return super.add(o);
		}

		public function get alignment(): int
		{
			return _alignment;
		}
		
		/**
		 * @see #setAlignment()
		 */
		public function set alignment( value: int ): void
		{
			_alignment = value;
		}
		
		/**
		 * Set the paragraph alignment
		 * 
		 * @see org.purepdf.elements.ElementTags#ALIGN_CENTER
		 * @see org.purepdf.elements.ElementTags#ALIGN_RIGHT
		 * @see org.purepdf.elements.ElementTags#ALIGN_JUSTIFIED
		 * @see org.purepdf.elements.ElementTags#ALIGN_JUSTIFIED_ALL
		 */
		public function setAlignment( value: String ): void
		{
			value = value.toLowerCase();
			if( ElementTags.ALIGN_CENTER.toLowerCase() == value ) {
				_alignment = Element.ALIGN_CENTER;
				return;
			}
			if ( ElementTags.ALIGN_RIGHT.toLowerCase() == value ) {
				_alignment = Element.ALIGN_RIGHT;
				return;
			}
			if ( ElementTags.ALIGN_JUSTIFIED.toLowerCase() == value ) {
				_alignment = Element.ALIGN_JUSTIFIED;
				return;
			}
			if ( ElementTags.ALIGN_JUSTIFIED_ALL.toLowerCase() == value ) {
				_alignment = Element.ALIGN_JUSTIFIED_ALL;
				return;
			}
			_alignment = Element.ALIGN_LEFT;
		}

		public function get extraParagraphSpace(): Number
		{
			return _extraParagraphSpace;
		}
		
		public function set extraParagraphSpace( value: Number ): void
		{
			_extraParagraphSpace = value;
		}

		public function get firstLineIndent(): Number
		{
			return _firstLineIndent;
		}
		
		public function set firstLineIndent( value: Number ): void
		{
			_firstLineIndent = value;
		}

		public function get indentationLeft(): Number
		{
			return _indentationLeft;
		}
		
		public function set indentationLeft( value: Number ): void
		{
			_indentationLeft = value;
		}

		public function get indentationRight(): Number
		{
			return _indentationRight;
		}
		
		public function set indentationRight( value: Number ): void
		{
			_indentationRight = value;
		}

		public function get keeptogether(): Boolean
		{
			return _keeptogether;
		}
		
		/**
		 * Indicates that the paragraph has to be 
		 * kept together on one page.
		 */
		public function set keeptogether( value: Boolean ): void
		{
			_keeptogether = value;
		}

		public function get multipliedLeading(): Number
		{
			return _multipliedLeading;
		}

		public function get spacingAfter(): Number
		{
			return _spacingAfter;
		}
		
		public function set spacingAfter( value: Number ): void
		{
			_spacingAfter = value;
		}
		
		public function set spacingBefore( value: Number ): void
		{
			_spacingBefore = value;
		}

		public function get spacingBefore(): Number
		{
			return _spacingBefore;
		}

		public function get totalLeading(): Number
		{
			var m: Number = _font == null ? Font.DEFAULTSIZE * _multipliedLeading : font.getCalculatedLeading( _multipliedLeading );

			if ( m > 0 && !hasLeading )
				return m;
			return leading + m;
		}

		override public function get type(): int
		{
			return Element.PARAGRAPH;
		}
		
		public function setLeading( fixedLeading: Number, multipliedLeading: Number ): void
		{
			_leading = fixedLeading;
			_multipliedLeading = multipliedLeading;
		}
	}
}