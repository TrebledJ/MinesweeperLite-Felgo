//	TextBase.qml

import QtQuick 2.0

Text {
	id: textBase
	
	property bool animate: false
	property bool firmAnchor: false
	
	//	note: colour-scheme is "lightgoldenrodyellow", "navy", "yellow"
	color: "navy"
	
	text: ""
	font.family: "Trebuchet MS"
//	font.family: trebuchetMs.name
	
	//	see: https://contingencycoder.wordpress.com/2013/08/05/quick-tip-load-fonts-from-a-local-file-with-qml/
	//		also check /qml/graphicmath/MathText
//	FontLoader { id: trebuchetMs; source: "qrc:/assets/TrebuchetMS.ttf" }
}
