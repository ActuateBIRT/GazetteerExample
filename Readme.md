# BIRT Gazetteer

---

## Overview
This iOS Objective-C example illustrates how to integrate OpenText Information Hub (iHub) 16 resources into a native mobile application. Two OpenText iHub APIs, the REST API, and the JavaScript API (JSAPI) retrieve data and visualizations from a your iHub 16 server. The iHub server resources used by this example are included with the source code.

![](/Screenshots/examples.png)

## Quick Start
1. Download the source code from this site.
2. Open the file Gazetteer.xcodeproj in Xcode.
3. Change the iHub server location in the source code (or use the gear icon in the lower right to change this at runtime).
4. Copy the report files to the iHub 16 server.
5. Copy the data file to iHub16 if it is not already there.
6. Build and run the project in an iOS simulator or iOS device.
7. Authenticate with your iHub server username and password.
8. Select a location from the list or map to view summary information.
9. Select Details to view a specific report about that location.

## Requirements
* Apple's Xcode 7.2.x or greater
* iOS 9.2 simulator or iPad device
* Access to reach an OpenText Information Hub 16 server

## Variables in source code
The following NSStrings are contained in the BIRTConstants.m file:
* REST_API_URL, you can change this value using the following URL format:
    http://[iHub server name]:8000/api/v2/
* IHUB_SERVER_URL, you can change this value using the following URL format:
    http://[iHub server name]:8700/
* REPORT_FOLDER, the file path where BIRT reports are located:
    /Home/administrator
* DATA_OBJECT_FOLDER, the file path where BIRT data objects are located:
    /Resources/Data Objects

## Resources in iHub 16 server
Install the world.data file in the
\Resources\Data Objects folder of the iHub volume.

Report designs for the application are stored in the administrator’s home folder in the volume. Install the following files into the \Home\administrator folder of the iHub volume:
* Continent Report Portrait.rptdesign
* Continent Report.rptdesign
* Country Report Portrait.rptdesign
* Country Report.rptdesign
* GDP per capita.rptdesign
* Map View Content.rptdesign
* Regional Report Portrait.rptdesign
* Regional Report.rptdesign
* World Report Portrait.rptdesign
* World Report.rptdesign

## REST API usage
The OpenText iHub server offers many RESTful URI endpoints to access stored resources on the server. This application uses Objective-C to make the following REST API requests:
* Authenticate the user to receive an authentication ID to attach to other REST API requests
* Download a list of locations values that are used to build BIRT reports
* Download data sets in JSON format for display in third-party visualizations

A RESTful URI request to a resource is built using the NSString class. Objective-C sends the NSString to the iHub server using NSURLConnection.

An NSDictionary object is created from the iHub server's JSON formatted response using the NSJSONSerialization class. The Objective-C code uses these NSDictionary values to request additional resources, display available location names in a table, and to display data about a location in a text string or an embedded visualization such as a chart.

## JavaScript API usage
The OpenText iHub server supports embedding interactive visualizations in web pages using the OpenText JavaScript API (JSAPI).

This application uses JSAPI to display iHub visualizations in iOS UIWebViews. JSAPI communicates with the iHub server using the authentication ID from the REST API login request. Objective-C code injects values into JSAPI requests before they are sent. The JSAPI then downloads and displays interactive BIRT content about the selected location using a bookmarked chart and a full page report. Bookmarks are a method to identify content in a BIRT report.

This application uses the following methods to communicate with the HTML content in the UIWebView:
* Replace string values in the embedded HTML file before loading the HTML file into the webview. This replacement uses the NSString's stringByReplacingOccurrencesOfString function to find string values in the jsapi.html file and replace those values with the current values, such as the server URL, and the username and password.
* Call the init JavaScript function embedded in the webview and pass the values required to display the BIRT content. This call uses the UIWebView's stringByEvaluatingJavaScriptFromString function to call the JavaScript function.

## Documentation
[Reporting and Information Hub APIs Programmer Guide](https://knowledge.opentext.com/knowledge/llisapi.dll/Open/62388776)

See the following chapters:
* Using iHub APIs for mobile applications
* Understanding the Gazetteer mobile application

[Forums for discussing BIRT technologies](http://developer.actuate.com/community/forum/)

[Additional information about integrating BIRT technology into applications](http://developer.actuate.com/deployment-center/integrating-birt-into-applications/)

## Credits
This example uses the following third party libraries:
* https://github.com/AlexandrGraschenkov/MagicPie
* https://github.com/zhuhuihuihui/Echart
* http://www.amcharts.com
