# Introduction #

There are different ways you can work with fonts in purePDF.


## Example 1 (Basic fonts) ##

Using one of the built-in fonts. First of all you need to link the **purePDFFont.swc** file (if you're not using the source). For the installation please refer to the [Installation](Installation.md) page.
When working with text you need always to have at least one font defined. If there's no font defined, an error will occur.
In order to register a font you will use the **FontsResourceFactory** class.

If you wan to register one of the builtin fonts (Helvetica, Courier, Times, Symbol or ZapfDingbats) this is the code to use:
```
FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA, new BuiltinFonts.HELVETICA() );
```
That's all. In fact, when you'll add some text in purePDF without specify the font to use, Helvetica will be used as default font. For this reason you need to have at least Helvetica defined when dealing with text.



and this is the basic example to work with fonts:
```
package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import org.purepdf.Font;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.Paragraph;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfDocument;
	import org.purepdf.pdf.PdfWriter;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.fonts.FontsResourceFactory;
	import org.purepdf.resources.BuiltinFonts;

	public class FontHowTo extends Sprite
	{
		private var writer: PdfWriter;
		private var document: PdfDocument;
		private var buffer: ByteArray;
		
		public function FontHowTo()
		{
			buffer = new ByteArray();
			writer = PdfWriter.create( buffer, PageSize.A4 );
			document = writer.pdfDocument;

			// register 'Helvetica' font
			FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA, new BuiltinFonts.HELVETICA() );
			
			document.open();
			
			// create a simple Paragraph using the default font
			// remember that the default font, if not specified is 'Helvetica'
			document.add( new Paragraph("Hello World" ) );
			
			// explicit declare the font
			var font: Font = new Font( Font.HELVETICA, 12, Font.NORMAL, RGBColor.DARK_GRAY, null );
			document.add( new Paragraph("Hello World", font ) );
			
			// create a new font using a BaseFont as source
			var baseFont: BaseFont = BaseFont.createFont( BaseFont.HELVETICA, BaseFont.WINANSI );
			font = new Font( Font.UNDEFINED, Font.UNDEFINED, Font.UNDEFINED, RGBColor.LIGHT_GRAY, baseFont );
			document.add( new Paragraph("Hello World", font ) );
			
			document.close();
			
			// create a simple button in order to let download
			// the created pdf file
			var button: Sprite = new Sprite();
			button.graphics.beginFill(0);
			button.graphics.drawRect( 0, 0, 100, 100 );
			button.addEventListener( MouseEvent.CLICK, onClick );
			addChild( button );
		}
		
		private function onClick( event: Event ): void
		{
			var file: FileReference = new FileReference();
			file.save( buffer, "font_example.pdf" );
		}
		
	}
}
```



## Example 2 ( embed a font ) ##

You can also decide to use a different font rather that one of the builtin fonts.
To do that you need to include the font file in the code ( using the Embed directive, or loading the bytearray font ).
The font then can be used. Moreover you can embed or not the font file in the final pdf document. If you don't want to embed that, only users with that font installed will see the correct text.
This is the code to embed a font:
```
var bf: BaseFont = BaseFont.createFont("CarolinaLTStd.otf", BaseFont.CP1252, BaseFont.EMBEDDED );
```

With BaseFont.EMBEDDED you will embed the font, otherwise use **BaseFont.NOT\_EMBEDDED**. The second parameter tells to purePDF which is the encoding of that font. In this case "cp-1252".

And this is the code example:
```
package wiki
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import org.purepdf.Font;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.Paragraph;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfDocument;
	import org.purepdf.pdf.PdfWriter;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.fonts.FontsResourceFactory;
	import org.purepdf.resources.BuiltinFonts;
	
	public class FontHowTo2 extends Sprite
	{
		private var writer: PdfWriter;
		private var document: PdfDocument;
		private var buffer: ByteArray;
		
		// embed the otf font file
		[Embed(source="/Users/alessandro/Library/Fonts/CarolinaLTStd.otf", mimeType="application/octet-stream")] private var cls1: Class;
		
		public function FontHowTo2()
		{
			buffer = new ByteArray();
			writer = PdfWriter.create( buffer, PageSize.A4 );
			document = writer.pdfDocument;
			
			// register 'CarolinaLTStd' font
			FontsResourceFactory.getInstance().registerFont("CarolinaLTStd.otf", new cls1());
			
			document.open();
			
			var bf: BaseFont = BaseFont.createFont("CarolinaLTStd.otf", BaseFont.CP1252, BaseFont.EMBEDDED );
			var font: Font = new Font( -1, -1, -1, RGBColor.BLACK, bf );
			
			document.add( new Paragraph("Hello World", font ) );
			document.close();
			
			// create a simple button in order to let download
			// the created pdf file
			var button: Sprite = new Sprite();
			button.graphics.beginFill(0);
			button.graphics.drawRect( 0, 0, 100, 100 );
			button.addEventListener( MouseEvent.CLICK, onClick );
			addChild( button );
		}
		
		private function onClick( event: Event ): void
		{
			var file: FileReference = new FileReference();
			file.save( buffer, "font_example2.pdf" );
		}
		
	}
}
```


## Unicode ##

In case you need to write unicode text you will also need a unicode capable font file. Pay attention to the encoding used within BaseFont.create
example:

```
package wiki
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import org.purepdf.Font;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.Paragraph;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfDocument;
	import org.purepdf.pdf.PdfWriter;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.fonts.FontsResourceFactory;
	import org.purepdf.resources.BuiltinFonts;
	
	public class FontHowTo3 extends Sprite
	{
		private var writer: PdfWriter;
		private var document: PdfDocument;
		private var buffer: ByteArray;
		
		// embed the otf font file
		[Embed(source="assets/fonts/AoyagiKouzanFont2.ttf", mimeType="application/octet-stream")] private var cls1: Class;
		
		public function FontHowTo3()
		{
			buffer = new ByteArray();
			writer = PdfWriter.create( buffer, PageSize.A4 );
			document = writer.pdfDocument;
			
			// register 'CarolinaLTStd' font
			FontsResourceFactory.getInstance().registerFont("japanese_unicode.otf", new cls1());
			
			document.open();
			
			var bf: BaseFont = BaseFont.createFont("japanese_unicode.otf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED );
			var font: Font = new Font( -1, 24, -1, RGBColor.BLACK, bf );
			
			document.add( new Paragraph("\u7121\u540d\u540e\u540f\u5410\u5421\u5413", font ) );
			document.close();
			
			// create a simple button in order to let download
			// the created pdf file
			var button: Sprite = new Sprite();
			button.graphics.beginFill(0);
			button.graphics.drawRect( 0, 0, 100, 100 );
			button.addEventListener( MouseEvent.CLICK, onClick );
			addChild( button );
		}
		
		private function onClick( event: Event ): void
		{
			var file: FileReference = new FileReference();
			file.save( buffer, "font_example3.pdf" );
		}
		
	}
}
```


## Unicode, vertical text and Cmaps ##

Using the buildints cjk fonts, so without the need to load external fonts, you can use CJK fonts and encoding. The only thing is that this requires additional steps before.
You won't use the FontsResourceFactory to register a new font, but the [CJKFontResourceFactory](http://code.google.com/p/purepdf/source/browse/trunk/src/org/purepdf/pdf/fonts/cmaps/CJKFontResourceFactory.as).
In addition the required cmaps should be loaded using [CMapResourceFactory](http://code.google.com/p/purepdf/source/browse/trunk/src/org/purepdf/pdf/fonts/cmaps/CMapResourceFactory.as).
For instance:
```
// load and register a cmap
var map: ICMap = new CMap( new CMap.UniGB_UCS2_H() );
CMapResourceFactory.getInstance().registerCMap( BaseFont.UniGB_UCS2_H, map );
			
// load and register a property
var prop: IProperties = new Properties();
prop.load( new BuiltinCJKFonts.STSong_Light() );
			
CJKFontResourceFactory.getInstance().registerProperty( BuiltinCJKFonts.getFontName( BuiltinCJKFonts.STSong_Light ), prop );
```

now you can write your unicode text in this way:
```
var bf: BaseFont = BaseFont.createFont( BuiltinCJKFonts.getFontName( BuiltinCJKFonts.STSong_Light ), BaseFont.UniGB_UCS2_H, BaseFont.NOT_EMBEDDED, true );
var font: Font = new Font( -1. -1, 32, -1, null, bf );
document.add( new Paragraph("\u5341\u950a\u57cb\u4f0f", font));
```

A couple of examples: [here](http://code.google.com/p/purepdf/source/browse/examples/src/ChineseKoreanJapanese.as) and [here](http://code.google.com/p/purepdf/source/browse/examples/src/VerticalTextExample.as)

## RTL ( Right to left writing ) ##

Some languages requires rtl writing. purepdf supports that.
In that case you can't directly add the Paragraph/Phrase or Chunk to the pdf document, but you need to use ColumnText.
example:

```
FontsResourceFactory.getInstance().registerFont( "arialuni.ttf", new cls() );
var bf: BaseFont = BaseFont.createFont( "arialuni.ttf", BaseFont.IDENTITY_H, true);
var font: Font = new Font( -1, 24, -1, null, bf );
var cb: PdfContentByte = writer.getDirectContent();
			
var p: Paragraph = new Paragraph("\u0646\u0642\u0644\u0643 \u0632\u0631 \u0636\u0631\u0628\u0629\u062D\u0638", font );
p.alignment = Element.ALIGN_LEFT;
			
ColumnText.showTextAligned( cb, Element.ALIGN_RIGHT, p, document.pageSize.width - 36, document.pageSize.height - 72, 0, PdfWriter.RUN_DIRECTION_RTL, 0);
```