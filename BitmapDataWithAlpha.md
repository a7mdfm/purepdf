# Introduction #

This is a trick for insert a BitmapData with transparency into a pdf document without the need to convert it into PNG first.


# Details #

```
/**
 * Create a transparent ImageElement
 * 
 * An ImageElement with the input bitmapdata RGB informations will be
 * created and an ImageElement will be used as mask ( using the alpha info from the bitmapdata )
 * If the input bitmapdata is not transparent a regular ImageElement will be returned. 
 */
protected function createTransparentImageElement( bitmap: BitmapData ): ImageElement
{
	var output: ByteArray = new ByteArray();
	var transparency: ByteArray = new ByteArray();
	var input: ByteArray = bitmap.getPixels( bitmap.rect );
	input.position = 0;
	
	while( input.bytesAvailable ){
		const pixel: uint = input.readInt();
		
		// write the RGB informations
		output.writeByte( (pixel >> 16) & 0xff );
		output.writeByte( (pixel >> 8) & 0xff );
		output.writeByte( (pixel >> 0) & 0xff );
		
		// write the alpha informations
		transparency.writeByte( (pixel >> 24) & 0xff );
	}
	
	output.position = 0;
	transparency.position = 0;
	
	var mask: ImageElement = ImageElement.getRawInstance( bitmap.width, bitmap.height, 1, 8, transparency, null );
	var image: ImageElement = ImageElement.getRawInstance( bitmap.width, bitmap.height, 3, 8, output, null );

	if( bitmap.transparent )
	{
		mask.makeMask();
		image.imageMask = mask;
	}
	return image;
}
```