package org.purepdf.pdf
{
	import it.sephiroth.utils.ObjectHash;
	
	import org.purepdf.utils.Bytes;

	public class PdfVersion extends ObjectHash
	{

		public static const PDF_VERSION_1_2: PdfName = new PdfName( "1.2" );
		public static const PDF_VERSION_1_3: PdfName = new PdfName( "1.3" );
		public static const PDF_VERSION_1_4: PdfName = new PdfName( "1.4" );
		public static const PDF_VERSION_1_5: PdfName = new PdfName( "1.5" );
		public static const PDF_VERSION_1_6: PdfName = new PdfName( "1.6" );
		public static const PDF_VERSION_1_7: PdfName = new PdfName( "1.7" );
		
		public static const VERSION_1_2: String = '2';
		public static const VERSION_1_3: String = '3';
		public static const VERSION_1_4: String = '4';
		public static const VERSION_1_5: String = '5';
		public static const VERSION_1_6: String = '6';
		public static const VERSION_1_7: String = '7';
		
		
		public static const HEADER: Vector.<Bytes> = Vector.<Bytes>( [ PdfWriter.getISOBytes( "\n" ), PdfWriter.getISOBytes( "%PDF-" ), PdfWriter
			.getISOBytes( "\n%\u00e2\u00e3\u00cf\u00d3\n" ) ] );
		protected var appendMode: Boolean = false;
		protected var catalog_version: PdfName = null;
		protected var headerWasWritten: Boolean = false;
		protected var extensions: PdfDictionary = null;
		protected var header_version: String = VERSION_1_4;

		public function addToCatalog( catalog: PdfDictionary ): void
		{
			if( catalog_version != null )
				catalog.put( PdfName.VERSION, catalog_version );
			
			if( extensions != null )
				catalog.put( PdfName.EXTENSIONS, extensions );
		}

		public function getVersionAsByteArray( version: String ): Bytes
		{
			return PdfWriter.getISOBytes( getVersionAsName( version ).toString().substring( 1 ) );
		}

		public function getVersionAsName( version: String ): PdfName
		{
			switch ( version )
			{
				case VERSION_1_2:
					return PDF_VERSION_1_2;
					
				case VERSION_1_3:
					return PDF_VERSION_1_3;
					
				case VERSION_1_4:
					return PDF_VERSION_1_4;
					
				case VERSION_1_5:
					return PDF_VERSION_1_5;

				case VERSION_1_6:
					return PDF_VERSION_1_6;
				
				case VERSION_1_7:
					return PDF_VERSION_1_7;
					
				default:
					return PDF_VERSION_1_4;
			}
		}

		public function setPdfVersion( value: String ): void
		{
			if ( headerWasWritten || appendMode )
			{
				setPdfVersionName( getVersionAsName( value ) );
			}
			else
			{
				header_version = value;
			}
		}

		public function writeHeader( os: OutputStreamCounter ): void
		{
			if( appendMode )
			{
				os.writeBytes( HEADER[0], 0, HEADER[0].length );
			} else {
				os.writeBytes( HEADER[ 1 ], 0, HEADER[ 1 ].length );
				os.writeBytes( getVersionAsByteArray( header_version ) );
				os.writeBytes( HEADER[ 2 ], 0, HEADER[ 2 ].length );
				headerWasWritten = true;
			}
		}

		private function setPdfVersionName( value: PdfName ): void
		{
			if ( catalog_version == null || catalog_version.compareTo( value ) < 0 )
				this.catalog_version = value;
		}
		
		internal function setAtLeastPdfVersion( version: String ): void
		{
			if( version.charCodeAt(0) > header_version.charCodeAt(0) )
			{
				setPdfVersion( version );
			}
		}
	}
}