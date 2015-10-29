# Introduction #

In this [example](http://code.google.com/p/purepdf/source/browse/examples/src/ShadingMultipleColors.as) you can see how to create multiple gradient colors ( with more than 2 colors ).

But let's say you want to recreate the same gradient ( with a custom matrix and rotation ) applied to a custom sprite with it's own custom matrix.

This is the effect you want to reproduce:


![http://www.sephiroth.it/purepdf/assets/images/gradient.png](http://www.sephiroth.it/purepdf/assets/images/gradient.png)

And this is the code we have in Flash for this sprite and gradient:

```
sprite_rotation = radians(15);   // degree * ( Math.PI / 180 );
fill_rotation = radians(30);

fill_rect = new Rectangle( 0, 0, 100, 100 );
gradient_matrix = new Matrix();

sprite = new Sprite();
var target: Graphics = sprite.graphics;

colors = [ 0xFF0000, 0x0000FF, 0x00FF00 ];
alphas = [ 1, 1, 1 ];
ratios = [ 0, 127, 255 ];
gradient_matrix.createGradientBox( fill_rect.width, fill_rect.height, fill_rotation, fill_rect.left, fill_rect.top );
			
target.beginGradientFill( GradientType.LINEAR, colors, alphas, ratios, gradient_matrix );
target.moveTo( 0, 0 );
target.lineTo( 100, 0 );
target.lineTo( 100, 100 );
target.lineTo( 0, 100 );
target.endFill();

var sprite_matrix: Matrix = new Matrix();
sprite_matrix.translate( -50, -50 );
sprite_matrix.rotate( sprite_rotation );
sprite_matrix.translate( 300, 300 );
sprite.transform.matrix = sprite_matrix;
```



# Details #

This is the code we will use to recreate the same effect like the flash one:


```
var cb: PdfContentByte = document.getDirectContent();

// we invert the canvas matrix, in this way we will have the
// same coordinate system as in flash
cb.setTransform( new Matrix( 1, 0, 0, -1, 0, pagesize.height ) );
			
cb.saveState();

// set the transformation matrix to our sprite matrix
cb.setTransform( sprite.transform.matrix );

// create the same gradient
cb_colors = Vector.<RGBColor>( [ RGBColor.fromARGB( 0xFFFF0000 ), RGBColor.fromARGB( 0xFF0000FF ), RGBColor.fromARGB( 0xFF00FF00 ) ] );
cb_ratios = Vector.<Number>( [ 0, 0.5, 1 ] );
var shading: PdfShading = PdfShading.complexAxial( writer, 0, 0, fill_rect.width, 0, cb_colors, cb_ratios, true, true );
var pattern: PdfShadingPattern = new PdfShadingPattern( shading );
			
var sprite_matrix: Matrix = sprite.transform.matrix.clone();
var m: Matrix = new Matrix();

// concatenate the sprite matrix to the gradient matrix
m.translate( -fill_rect.width/2, -fill_rect.height/2 );
m.rotate( fill_rotation );
m.translate( fill_rect.left + fill_rect.width/2, fill_rect.height/2 );
m.concat( sprite_matrix );
m.concat(new Matrix( 1, 0, 0, -1, 0, pagesize.height ));

// ..and apply the result matrix to our pattern
pattern.matrix = m.clone();

// now draw our sprite in the same way as flash
cb.moveTo( 0, 0 );
cb.lineTo( 100, 0 );
cb.lineTo( 100, 100 );
cb.lineTo( 0, 100 );

// and apply the gradient to it
cb.setShadingFill( pattern );
cb.fill();
cb.restoreState();
```


## Conclusion ##

This is the resulting pdf file: http://www.sephiroth.it/purepdf/pdfs/AdvancedGradient.pdf

And this is the complete code I've used:

```
package wiki
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfShading;
	import org.purepdf.pdf.PdfShadingPattern;

	public class Test extends DefaultBasicExample
	{
		private var alphas: Array;
		private var cb_alphas: Vector.<Number>;

		private var cb_colors: Vector.<RGBColor>;
		private var cb_ratios: Vector.<Number>;

		private var colors: Array;
		private var fill_rect: Rectangle;
		private var fill_rotation: Number;

		private var gradient_matrix: Matrix;
		private var ratios: Array;
		private var sprite: Sprite;
		private var pagesize: RectangleElement;
		private var sprite_rotation: Number;

		public function Test()
		{
			super( null );
			
			pagesize = PageSize.create( 500, 500 );
			sprite_rotation = radians(15);
			fill_rotation = radians(30);

			fill_rect = new Rectangle( 0, 0, 100, 100 );
			gradient_matrix = new Matrix();

			sprite = new Sprite();
			var target: Graphics = sprite.graphics;

			cb_colors = Vector.<RGBColor>( [ RGBColor.fromARGB( 0xFFFF0000 ), RGBColor.fromARGB( 0xFF0000FF ), RGBColor.fromARGB( 0xFF00FF00 ) ] );
			cb_ratios = Vector.<Number>( [ 0, 0.5, 1 ] );

			colors = [ 0xFF0000, 0x0000FF, 0x00FF00 ];
			alphas = [ 1, 1, 1 ];
			ratios = [ 0, 127, 255 ];

			gradient_matrix.createGradientBox( fill_rect.width, fill_rect.height, fill_rotation, fill_rect.left, fill_rect.top );
			
			target.beginGradientFill( GradientType.LINEAR, colors, alphas, ratios, gradient_matrix );
			target.moveTo( 0, 0 );
			target.lineTo( 100, 0 );
			target.lineTo( 100, 100 );
			target.lineTo( 0, 100 );
			target.endFill();

			var sprite_matrix: Matrix = new Matrix();
			sprite_matrix.translate( -50, -50 );
			sprite_matrix.rotate( sprite_rotation );
			sprite_matrix.translate( 300, 300 );
			sprite.transform.matrix = sprite_matrix;

			addChild( sprite );
		}

		override protected function execute( event: Event = null ): void
		{
			super.execute();

			createDocument( "", pagesize );
			document.open();

			var cb: PdfContentByte = document.getDirectContent();

			cb.setTransform( new Matrix( 1, 0, 0, -1, 0, pagesize.height ) );
			
			cb.saveState();
			cb.setTransform( sprite.transform.matrix );

			var shading: PdfShading = PdfShading.complexAxial( writer, 0, 0, fill_rect.width, 0, cb_colors, cb_ratios, true, true );
			var pattern: PdfShadingPattern = new PdfShadingPattern( shading );
			
			var sprite_matrix: Matrix = sprite.transform.matrix.clone();
			var m: Matrix = new Matrix();

			m.translate( -fill_rect.width/2, -fill_rect.height/2 );
			m.rotate( fill_rotation );
			m.translate( fill_rect.left + fill_rect.width/2, fill_rect.height/2 );
			m.concat( sprite_matrix );
			m.concat(new Matrix( 1, 0, 0, -1, 0, pagesize.height ));

			pattern.matrix = m.clone();

			cb.moveTo( 0, 0 );
			cb.lineTo( 100, 0 );
			cb.lineTo( 100, 100 );
			cb.lineTo( 0, 100 );

			cb.setShadingFill( pattern );
			cb.fill();
			cb.restoreState();

			document.close();
			save();
		}

		public static function degrees( radians: Number ): Number
		{
			return radians * ( 180 / Math.PI );
		}

		public static function radians( degree: Number ): Number
		{
			return degree * ( Math.PI / 180 );
		}
	}
}
```