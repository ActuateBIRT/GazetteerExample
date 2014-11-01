#BIRT Gazetteer
==============

##Overview
This iOS Objective-C example illustrates how to integrate BIRT iHub resources into a native mobile application. Two BIRT APIs, the REST API, and the JavaScript API (JSAPI) retrieve data and visualizations from a demonstration BIRT iHub 3.1 server. The iHub server resources used by this example are included with the source code if you want to use your own BIRT iHub server.

## Quick Start
1. Download the source code from this site.
2. Open the file Gazetteer.xcodeproj in Xcode.
3. Build and run the project in an iOS simulator or iOS device.
4. Authenticate with username "demo" and password "demo."
5. Select a location from the list or map to view summary information.
6. Select Details to view a specific report about that location.

## Requirements
* Apple's Xcode 5.x or greater
* iOS 7.1 simulator or iPad device
* Internet access to reach the demo BIRT iHub 3.1 server

## REST API usage
The BIRT iHub server offers many RESTful URI endpoints to access stored resources on the server. This application uses Objective-C to make the following REST API requests:
* Authenticate the user to receive an authentication ID to attach to other REST API requests
* Download a list of locations values that are used to build BIRT reports
* Download data sets in JSON format for display in third-party visualizations

A RESTful URI request to a resource is built using the NSString class. Objective-C sends the NSString to the iHub server using NSURLConnection. 

An NSDictionary object is created from the iHub server's JSON formatted response using the NSJSONSerialization class. The Objective-C code uses these NSDictionary values to request additional resources, display available location names in a table, and to display data about a location in a text string or an embedded visualization such as a chart.

## JavaScript API usage
The BIRT iHub server supports embedding interactive visualizations in web pages using the Actuate JavaScript API (JSAPI).

This application uses JSAPI to display BIRT visualizations in iOS UIWebViews. JSAPI communicates with the iHub server using the authentication ID from the REST API login request. Objective-C code injects values into JSAPI requests before they are sent. The JSAPI then downloads and displays interactive BIRT content about the selected location using a bookmarked chart and a full page report. Bookmarks are a method to identify content in a BIRT report.

This application uses the following methods to communicate with the HTML content in the UIWebView:
* Replace string values in the embedded HTML file before loading the HTML file into the webview. This replacement uses the NSString's stringByReplacingOccurrencesOfString function to find string values in the jsapi.html file and replace those values with the current values, such as the server URL, and the username and password.
* Call the init JavaScript function embedded in the webview and pass the values required to display the BIRT content. This call uses the UIWebView's stringByEvaluatingJavaScriptFromString function to call the JavaScript function.

## Documentation
Additional information about integrating BIRT technology into applications is available at the following URL:
http://developer.actuate.com/deployment-center/integrating-birt-into-applications/

Forums for discussing BIRT technologies are available at the following URL:
http://developer.actuate.com/community/forum/

## Credits
This example uses the following third party libraries:
* https://github.com/AlexandrGraschenkov/MagicPie
* https://github.com/zhuhuihuihui/Echart
* http://www.amcharts.com