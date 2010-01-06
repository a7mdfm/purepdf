package
{
	
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.getQualifiedClassName;
	
	import org.purepdf.colors.RGBColor;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfBlendMode;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfDocument;
	import org.purepdf.pdf.PdfGState;
	import org.purepdf.pdf.PdfWriter;
	
	public class GraphicState extends DefaultBasicExample
	{
		public function GraphicState()
		{
			super();
		}
		
		override protected function createDescription() : void
		{
			description("This example will show some usage of the","graphic state (PdfGState) applied to the","pdf content in order to","modify the opacity and blend modes");
		}
		
		override protected function execute(event:Event=null) : void
		{
			super.execute();
			
			var document: PdfDocument = PdfWriter.create( buffer, PageSize.A4 );
			
			document.open();
			document.addAuthor( "Alessandro Crugnola" );
			document.addTitle( getQualifiedClassName( this ) );
			document.addCreator( "http://purepdf.org" );
			document.addSubject( "Graphic state example" );
			
			var cb: PdfContentByte = document.getDirectContent();
			var gs: PdfGState;
			cb.setTransform( new Matrix( 1, 0, 0, -1, 0, document.getPageSize().getHeight() ) );
			
			cb.saveState();
			cb.setFillColor( new RGBColor( 255, 0, 0 ) );
			cb.circle( 100, 100, 50 );
			cb.fill();
			cb.restoreState();
			
			cb.saveState();
			cb.setFillColor( new RGBColor( 0, 0, 255 ) );
			cb.setTransform( new Matrix( 1, 0, 0, 1, 25, 50 ) );
			gs = new PdfGState();
			gs.setFillOpacity( 0.5 );	// change the fill opacity
			cb.setGState( gs );
			cb.circle( 100, 100, 50 );
			cb.fill();
			cb.restoreState();
			
			cb.saveState();
			cb.setFillColor( new RGBColor( 0, 255, 0 ) );
			cb.setTransform( new Matrix( 1, 0, 0, 1, 50, 0 ) );
			gs = new PdfGState();
			gs.setBlendMode( PdfBlendMode.MULTIPLY );	// use blendmode
			cb.setGState( gs );
			cb.circle( 100, 100, 50 );
			cb.fill();
			cb.restoreState();
			
			document.close();
			save();
		}
	}
}