# Introduction #

This is an example made in Adobe AIR about how to generate a photo album from an existing directory of images with page labels and transitions.


# Details #

PhotoAlbum.mxml code. Just link the purePDF svn source library or the downloaded swc files and then paste this code in your air project.

```
<?xml version="1.0" encoding="utf-8"?>
<s:WindowedApplication xmlns:fx="http://ns.adobe.com/mxml/2009" 
					   xmlns:s="library://ns.adobe.com/flex/spark" 
					   xmlns:mx="library://ns.adobe.com/flex/mx"
					   maxHeight="310"
					   initialize="onInitialized(event)">
	<fx:Script>
		<![CDATA[
			import flash.display.Bitmap;
			import flash.display.BitmapData;
			import flash.display.Loader;
			import flash.display.LoaderInfo;
			import flash.events.Event;
			import flash.events.MouseEvent;
			import flash.events.TimerEvent;
			import flash.net.FileReference;
			import flash.net.URLRequest;
			import flash.utils.ByteArray;
			import flash.utils.Timer;
			
			import flashx.textLayout.formats.Direction;
			
			import mx.events.FlexEvent;
			import mx.events.ListEvent;
			
			import org.osmf.events.TimeEvent;
			import org.purepdf.elements.RectangleElement;
			import org.purepdf.elements.images.ImageElement;
			import org.purepdf.events.PageEvent;
			import org.purepdf.pdf.PageSize;
			import org.purepdf.pdf.PdfBlendMode;
			import org.purepdf.pdf.PdfContentByte;
			import org.purepdf.pdf.PdfDocument;
			import org.purepdf.pdf.PdfGState;
			import org.purepdf.pdf.PdfPageLabels;
			import org.purepdf.pdf.PdfTransition;
			import org.purepdf.pdf.PdfVersion;
			import org.purepdf.pdf.PdfViewPreferences;
			import org.purepdf.pdf.PdfWriter;
			import org.purepdf.pdf.fonts.BaseFont;
			import org.purepdf.pdf.fonts.FontsResourceFactory;
			import org.purepdf.resources.BuiltinFonts;

			[Bindable] protected var directory: File;
			
			protected var buffer: ByteArray;
			protected var pdf: PdfDocument;
			protected var writer: PdfWriter;
			protected var labels: PdfPageLabels;
			protected var filelist: Array;
			protected var current_file: File;
			protected var bf: BaseFont;
			protected var image_index: int = 0;
			protected var image_total: int = 0;
			protected var margins: int;
			protected var scale: int;
			
			private var timer: Timer;
			
			protected function execute(): void
			{
				margins = page_margins.value;
				scale = image_scale.value;
				
				buffer = new ByteArray();
				writer = PdfWriter.create( buffer, PageSize.A4 );
				pdf = writer.pdfDocument;
				
				pdf.setPdfVersion( PdfVersion.VERSION_1_5 );
				
				if( page_transitions.selected )
					pdf.addEventListener( PageEvent.PAGE_START, onStartPage );
				
				if( page_fullscreen.selected )
					pdf.setViewerPreferences( PdfViewPreferences.PageModeFullScreen );
				else
					pdf.setViewerPreferences( PdfViewPreferences.PageModeUseThumbs );
				
				labels = new PdfPageLabels();
				
				filelist = directory.getDirectoryListing();
				
				image_index = 0;
				image_total = filelist.length;
				
				timer = new Timer( 10, 1 );
				timer.addEventListener(TimerEvent.TIMER, onTimer );
				next();
			}
			
			protected function processImage( b: ByteArray ): void
			{
				var caption: String = current_file.name;
				var image: ImageElement = ImageElement.getInstance( b );
				image.scalePercent( scale, scale );
				pdf.pageSize = new RectangleElement( 0, 0, image.scaledWidth + (margins*2), image.scaledHeight + (margins*2) );
				
				if( pdf.opened )
					pdf.newPage();
				else
					pdf.open();
				
				image.setAbsolutePosition( margins, margins );
				pdf.add( image );
				
				var gs1: PdfGState = new PdfGState();
				gs1.setBlendMode( PdfBlendMode.OVERLAY );
				var cb: PdfContentByte = pdf.getDirectContent();
				cb.saveState();
				cb.setGState( gs1 );
				cb.beginText();
				cb.setFontAndSize( bf, 30 );
				cb.setTextMatrix( 1, 0, 0, 1, margins + 10, margins + 10 );
				cb.showText( caption );
				cb.endText();
				cb.restoreState();
				
				var label: String = current_file.name;
				if( label.indexOf(".") > 0 )
					label = label.substr( 0, label.lastIndexOf(".") );
				labels.addPageLabel( pdf.pageNumber, PdfPageLabels.EMPTY, label );
				next();
			}
			
			protected function onTimer( event: TimerEvent ): void
			{
				var loader: Loader;
				image_index++;
				if( filelist.length > 0 )
				{
					current_file = filelist.shift();
					progress.setProgress( image_index, image_total );
					
					if( "jpg" == current_file.extension.toLowerCase() )
					{
						var b: ByteArray = new ByteArray();
						var fs: FileStream = new FileStream();
						fs.open( current_file, FileMode.READ );
						fs.readBytes( b );
						processImage( b );
					} else 
					{
						next();
					}
				} else 
				{
					complete();
				}
			}
			
			protected function next(): void
			{
				timer.reset();
				timer.start();
			}
			
			protected function complete(): void
			{
				pdf.setPageLabels( labels );
				pdf.close();
				
				var f: File = new File();
				f.browseForSave("Save as");
				f.addEventListener(Event.SELECT, saveData);
			}
			
			private function saveData( event: Event ): void
			{
				var f: File = event.target as File;
				buffer.position = 0;
				
				var stream: FileStream = new FileStream();
				stream.open( f, FileMode.WRITE);
				stream.writeBytes( buffer, 0, buffer.length );
				stream.close();
			}

			protected function button1_clickHandler(event:MouseEvent):void
			{
				if( directory != null && directory.isDirectory )
					execute();
			}


			protected function onInitialized(event:FlexEvent):void
			{
				FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA, new BuiltinFonts.HELVETICA() );
				bf = BaseFont.createFont( BaseFont.HELVETICA, BaseFont.WINANSI, false );
			}

			protected function button2_clickHandler(event:MouseEvent):void
			{
				var f: File = File.userDirectory;
				f.browseForDirectory("Select images directory");
				f.addEventListener( Event.SELECT, onDirectorySelected );
			}
			
			private function onDirectorySelected( event: Event ): void
			{
				var f: File = event.target as File;
				if( f.exists && f.isDirectory )
				{
					directory = f;
					directory_path.text = f.name;
				}
			}
			
			private function onStartPage( event: PageEvent ): void
			{
				var transition: PdfTransition = PdfTransition.RANDOM;
				pdf.transition = transition;
				pdf.duration = 2;
			}
			

		]]>
	</fx:Script>
	<fx:Declarations>
	</fx:Declarations>
	<s:VGroup left="10" right="10" bottom="10" top="10">
		<mx:Form>
			<mx:FormItem label="directory" direction="horizontal">
				<s:TextInput enabled="false" id="directory_path" minWidth="250"/>
				<s:Button label="browse..." click="button2_clickHandler(event)" />				
			</mx:FormItem>
			<mx:FormItem label="page margins">
				<s:NumericStepper minimum="0" maximum="100" id="page_margins" value="36" />
			</mx:FormItem>
			<mx:FormItem label="image scale">
				<s:NumericStepper minimum="10" maximum="100" id="image_scale" value="100" />
			</mx:FormItem>
			<mx:FormItem label="fullscreen">
				<s:CheckBox selected="true" id="page_fullscreen" />
			</mx:FormItem>
			<mx:FormItem label="page transitions">
				<s:CheckBox selected="true" id="page_transitions" />
			</mx:FormItem>
			<mx:FormItem horizontalAlign="right" width="100%">
				<s:Button label="Create!" click="button1_clickHandler(event)" enabled="{directory != null}" id="create_button" />				
			</mx:FormItem>
		</mx:Form>
		<mx:ProgressBar width="100%" mode="manual" id="progress" />
	</s:VGroup>
</s:WindowedApplication>

```