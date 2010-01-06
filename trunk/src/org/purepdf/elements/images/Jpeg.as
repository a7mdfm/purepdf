package org.purepdf.elements.images
{
	import flash.errors.IOError;
	import flash.utils.ByteArray;
	
	import org.purepdf.utils.Bytes;

	public class Jpeg extends ImageElement
	{
		public static const NOT_A_MARKER: int = -1;
		public static const VALID_MARKER: int = 0;
		public static const VALID_MARKERS: Vector.<int> = Vector.<int>([0xC0, 0xC1, 0xC2]);
		public static const UNSUPPORTED_MARKER: int = 1;
		public static const UNSUPPORTED_MARKERS: Vector.<int> = Vector.<int>([0xC3, 0xC5, 0xC6, 0xC7, 0xC8, 0xC9, 0xCA, 0xCB, 0xCD, 0xCE, 0xCF]);
		public static const NOPARAM_MARKER: int = 2;
		public static const NOPARAM_MARKERS: Vector.<int> = Vector.<int>([0xD0, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD7, 0xD8, 0x01]);
		public static const M_APP0: int = 0xE0;
		public static const M_APP2: int = 0xE2;
		public static const M_APPE: int = 0xEE;
		public static const JFIF_ID: Vector.<int> = Vector.<int>([0x4A, 0x46, 0x49, 0x46, 0x00]);
		
		private var icc: Vector.<Bytes>;
		
		public function Jpeg( buffer: ByteArray )
		{
			super( null );
			buffer.position = 0;
			
			_rawData = buffer;
			_rawData.position = 0;
			_originalData = buffer;
			
			processParameters();
		}
		
		/**
		 * Reads a short from the <CODE>InputStream</CODE>.
		 *
		 * @param	is		the <CODE>InputStream</CODE>
		 * @return	an int
		 * @throws IOException
		 */
		private static function getShort( ins: ByteArray ): int
		{
			return (ins.readUnsignedByte() << 8) + ins.readUnsignedByte();
		}
		
		private static function getMarker( marker: int ): int
		{
			var i: int;
			for( i = 0; i < VALID_MARKERS.length; i++ )
			{
				if( marker == VALID_MARKERS[i] )
					return VALID_MARKER;
			}
			
			for( i = 0; i < NOPARAM_MARKERS.length; i++ )
			{
				if( marker == NOPARAM_MARKERS[i] )
					return NOPARAM_MARKER;
			}
			
			for( i = 0; i < UNSUPPORTED_MARKERS.length; i++ )
			{
				if( marker == UNSUPPORTED_MARKERS[i] )
					return UNSUPPORTED_MARKER;
			}
			return NOT_A_MARKER;
		}
		
		private function processParameters(): void
		{
			_type = JPEG;
			_originalType = ORIGINAL_JPEG;
			var ins: ByteArray;
			var errorID: String;
			
			ins = new ByteArray();
			ins.writeBytes( _rawData, 0, _rawData.length );
			ins.position = 0;
			
			errorID = "Byte Array";
			
			if( ins.readUnsignedByte() != 0xFF || ins.readUnsignedByte() != 0xD8 )
			{
				throw new Error("Invalid Jpeg File");
			}
			
			var firstPass: Boolean = true;
			var len: int;
			var v: int;
			var marker: int;
			var found: Boolean;
			var k: int;
			
			while( true )
			{
				v = ins.readUnsignedByte();
				if( v < 0 )
					throw new IOError("Premature end of file");
				if( v == 0xFF )
				{
					marker = ins.readUnsignedByte();
					if( firstPass && marker == M_APP0 )
					{
						firstPass = false;
						len = getShort( ins );
						
						if( len < 16 )
						{
							ins.position += len - 2;
							continue;
						}
						
						var bcomp: Bytes = new Bytes();
						ins.readBytes( bcomp.buffer, 0, JFIF_ID.length );
						
						found = true;
						for( k = 0; k < bcomp.length; ++k )
						{
							if( bcomp[k] != JFIF_ID[k] )
							{
								found = false;
								break;
							}
						}
						
						if( !found )
						{
							ins.position += len - 2 - bcomp.length;
							continue;
						}
						
						ins.position += 2;
						var units: int = ins.readUnsignedByte();
						var dx: int = getShort( ins );
						var dy: int = getShort( ins );
						if( units == 1 )
						{
							dpiX = dx;
							dpiY = dy;
						} else if( units == 2 )
						{
							dpiX = (dx * 2.54 + 0.5);
							dpiY = (dx * 2.54 + 0.5);
						}
						
						ins.position += len - 2 - bcomp.length - 7;
						continue;
					}
					
					if( marker == M_APPE )
					{
						len = getShort( ins ) - 2;
						var byteappe: Bytes = new Bytes();
						for( k = 0; k < len; ++k )
						{
							byteappe[k] = ins.readUnsignedByte();
						}
						
						if( byteappe.length >= 12 )
						{
							var appe: String = byteappe.readAsString( 0, 5 );
							if( appe == "Adobe" )
								_invert = true;
						}
						continue;
					}
					
					if( marker == M_APP2 )
					{
						len = getShort( ins ) - 2;
						var byteapp2: Bytes = new Bytes();
						
						for( k = 0; k < len; ++k )
						{
							byteapp2[k] = ins.readUnsignedByte();
						}
						
						if( byteapp2.length >= 14 )
						{
							var app2: String = byteapp2.readAsString( 0, 11 );
							if( app2 == "ICC_PROFILE" )
							{
								var order: int = byteapp2[12] & 0xFF;
								var count: int = byteapp2[13] & 0xFF;
								if( order < 1 )
									order = 1;
								if( count < 1 )
									count = 1;
								if( icc == null )
									icc = new Vector.<Bytes>();
								
								icc[ order - 1 ] = byteapp2;
							}
						}
						continue;
					}
					
					firstPass = false;
					var markerType: int = getMarker( marker );
					if( markerType == VALID_MARKER )
					{
						ins.position += 2;
						if( ins.readUnsignedByte() != 0x08 )
						{
							throw new Error("Must have 8 bits per component");
						}
						
						scaledHeight = getShort( ins );
						setTop( scaledHeight );
						scaledWidth = getShort( ins );
						setRight( scaledWidth );
						_colorspace = ins.readUnsignedByte();
						_bpc = 8;
						break;
					} else if( markerType == UNSUPPORTED_MARKER )
					{
						throw new Error("Unsupported jpeg marker: " + markerType.toString() );
					} else if( markerType != NOPARAM_MARKER )
					{
						ins.position += getShort( ins ) - 2;
					}
				}
			}
			
			plainWidth = getWidth();
			plainHeight = getHeight();
			
			if( icc != null )
			{
				var total: int = 0;
				for( k = 0; k < icc.length; ++k )
				{
					if( icc[k] == null )
					{
						icc = null;
						return;
					}
					total += icc[k].length - 14;
				}
				
				var ficc: Bytes = new Bytes();
				total = 0;
				
				for( k = 0; k < icc.length; ++k )
				{
					//System.arrayCopy( icc[k], 14, ficc, total, icc[k].length - 14 );
					total += icc[k].length - 14;
				}
				
				icc =  null;
			}
		}
		
		
	}
}