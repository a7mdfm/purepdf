# Introduction #

purepdf it's compiled using [ant](http://ant.apache.org/).
Download and install apache ant, then download [flexTaks](http://labs.adobe.com/wiki/index.php/Flex_Ant_Tasks) and [ant-contrib](http://ant-contrib.sourceforge.net/) ant tasks.

Open with a text editor the boundled file "build.properties" and set the correct path to your flex 4 sdk folder.

Open your terminal and move to the purepdf folder. Then type:
```
ant compile-all
```
to compile the entire project. This task will create 2 different swc files: "purePDF.swc" and "purePDFont.swc".

```
ant compile
```
will compile only the purePDF.swc file and
```
ant compile-fonts
```
will compile only the purePDFont.swc file

# Details #

The project has been splitted into 2 different swc files because if you don't need to add text to your pdf file there's no need to include also the builtin pdf fonts included in the purePDFont.swc file. Otherwise you need to link the purePDFont.swc and use the BuiltinFonts.as class to register one of the builtin fonts embedded.