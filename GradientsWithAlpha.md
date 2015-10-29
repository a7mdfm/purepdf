# Introduction #

Here's how to create a linear gradient with different colors. Each color has its own alpha value.

This is an example output: http://www.sephiroth.it/purepdf/pdfs/ShadingGradientTransparency.pdf


# Details #

With purepdf you can't create directly a gradient matrix using ARGB colors, but you have to use a mask which defines the opacity of the desired shape.
Here an example code:


```
var cb: PdfContentByte = document.getDirectContent();

// prepare the gradient box path
cb.moveTo(x, y);
cb.lineTo(x + width, y);
cb.lineTo(x + width, y + height);
cb.lineTo(x, y + height);

// create template
var template: PdfTemplate = cb.createTemplate(x+width, y+height);

// prepare the transparency group
var transGroup: PdfTransparencyGroup = new PdfTransparencyGroup();
transGroup.put(PdfName.CS, PdfName.DEVICERGB);
transGroup.isolated = true;
transGroup.knockout = false;
template.group = transGroup;

// prepare the graphic state
var gState: PdfGState = new PdfGState();
var maskDict: PdfDictionary = new PdfDictionary();
maskDict.put(PdfName.TYPE, PdfName.MASK);
maskDict.put(PdfName.S, new PdfName("Luminosity"));
maskDict.put(new PdfName("G"), template.indirectReference );
gState.put(PdfName.SMASK, maskDict);
cb.setGState(gState);

var shading: PdfShading = PdfShading.complexAxial( 
	writer, 0, y, 0, height, 
	Vector.<RGBColor>([ new GrayColor(1), new GrayColor(0), new GrayColor(.5), new GrayColor(1), new GrayColor(1), new GrayColor(0.2), new GrayColor(1) ]),
	null
);
template.paintShading(shading);

// Draw the actual colour under the mask
shading = PdfShading.complexAxial( 
	writer, 0, y, 0, height,
	Vector.<RGBColor>([ RGBColor.YELLOW, RGBColor.BLACK, RGBColor.CYAN, RGBColor.GREEN, RGBColor.BLUE, RGBColor.ORANGE , RGBColor.MAGENTA ]),
	null
);

var axialPattern: PdfShadingPattern = new PdfShadingPattern( shading );

cb.setShadingFill( axialPattern );
cb.fill();
```