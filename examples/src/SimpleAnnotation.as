package 
{
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfAnnotation;
	import org.purepdf.pdf.PdfDocument;
	import org.purepdf.pdf.PdfWriter;

	public class SimpleAnnotation extends DefaultBasicExample
	{
		public function SimpleAnnotation()
		{
			super();
		}
		
		override protected function createDescription() : void
		{
			description("This Example will show how to create simple","annotations to a pdf page");
		}
		
		override protected function execute(event:Event=null) : void
		{
			super.execute();
			
			var rect: RectangleElement = PageSize.A4;
			var document: PdfDocument = PdfWriter.create( buffer, rect );
			
			document.open();
			document.addAuthor( "Alessandro Crugnola" );
			document.addTitle( getQualifiedClassName(this) );
			
			document.addAnnotation( 
				PdfAnnotation.createText( new RectangleElement( 300, 700, 300, 700 ), 
				"Note", "This is a Note created with purepdf!\nThis is the default behavior for opened annotations", true, "Note" ) 
			);
			
			document.addAnnotation( 
				PdfAnnotation.createText( new RectangleElement( 260, 700, 260, 700 ), 
					"Comment", "This is a Comment created with purepdf!\nThis is the default behavior for closed annotations", false, "Comment" ) 
			);
			
			document.close();
			
			save();
		}
	}
}