# Introduction #

With PdfLayerMembership you can provide optional contents to a pdf document. PdfLayerMembership can be used like a PdfLayer, so you can draw everything you want in it.<br />
With PdfLayerMembership you assign members ( other PdfLayer(s) ) and a visibilityPolicy. <br />
visibilityPolicy can be one of these PdfLayerMembership public constants: **ALLON**, **ALLOFF**, **ANYON**, **ANYOFF**.<br />
In this way, once the visibility policy is satisfied the PdfLayerMembership instance will be visible, otherwise it will remains invisible into the pdf document.


# Details #

Take this example code:
```
var dog: PdfLayer = new PdfLayer("Layer 1", writer);
var tiger: PdfLayer = new PdfLayer("Layer 2", writer);
var lion: PdfLayer = new PdfLayer("Layer 3", writer);


var no_cat: PdfLayerMembership = new PdfLayerMembership( writer );
no_cat.addMember( tiger );
no_cat.addMember( lion );
no_cat.visibilityPolicy = PdfLayerMembership.ALLOFF;
```

In this example, the **no\_cat** layer will be visible into the pdf document only once both **tiger** and **lion** layers will be set invisible ( for instance by the user who is reading the document )

For a practical example see this: [LayerMembershipExample.as](http://code.google.com/p/purepdf/source/browse/examples/src/LayerMembershipExample.as)