/*=============================================
= Report =
=============================================*/

function getType() {
    var type;
    if (mapObject.parentObject.map == "continentsLow") {
        type = "Continent";
    } else if (mapObject.parentObject.map == "regionsLow") {
        type = "Region";
    } else if (mapObject.parentObject.map == "northAmericaLow" ||
               mapObject.parentObject.map == "europeLow" ||
               mapObject.parentObject.map == "asiaLow" ||
               mapObject.parentObject.map == "africaLow" ||
               mapObject.parentObject.map == "southAmericaLow" ||
               mapObject.parentObject.map == "oceaniaLow" ||
               mapObject.parentObject.map == "worldLow" ) {
        type = "Country";
    } else {
        type = "World" ;
    }
    return type;
}


function loadMapViewReport() {
        if (actuate.viewer.impl) {
        var that = actuate.viewer.impl.Viewer;
        if ( that._viewersMap )
        {
            that._viewersMap.remove( "sidebar-1" );
        }
    }
    
    var inputData=[];
    if (mapObject) {
        type = getType();
    } else {
        type ='World';
    }
    
    inputData["type"] = type;
    
    if (type != "World") {
        jQuery.each(worldDataSet, function (i, item) {
                    var d = item;
                    if (item[type] == mapObject.title) {
                    inputData["continent"] = item.Continent;
                    inputData["region"] = item.Region;
                    inputData["country"] = item.Country;
                    inputData["type"] = type;
                    initMapView(inputData);
                    return false;
                    }
                    });
    } else {
        initMapView(inputData);
    }
}

function loadReport() {
    var that = actuate.viewer.impl.Viewer;
    if ( that._viewersMap )
    {
        that._viewersMap.remove( "report" );
    }
    
    var inputData=[];
    var type;
    if (mapObject) {
        type = getType();
    } else {
        type ='World';
    }
    inputData["type"] = type;
    if (type != "World") {
        jQuery.each(worldDataSet, function (i, item) {
                    var d = item;
                    if (item[type] == mapObject.title) {
                    inputData["continent"] = item.Continent;
                    inputData["region"] = item.Region;
                    inputData["country"] = item.Country;
                    inputData["type"] = type;
                    initReportView(inputData);
                    return false;
                    }
                    });
    }  else {
        initReportView(inputData);
    }
}


function initMapView(inputData) {
    var report = report_folder + 'Map View Content.rptdesign';
    
    if (actuate && actuate.isInitialized()) {
        loadViewer(inputData, report, "sidebar-1", true);
    } else {
        var reqOps = new actuate.RequestOptions( );
        reqOps.setVolumeProfile( "default volume" );
        reqOps.setVolume( "default volume" );
        actuate.load("viewer");
        actuate.initialize(
                           baseUrl,
                           reqOps,
                           userName,
                           password,
                           function()
                           {
                           
                           loadViewer(inputData, report, "sidebar-1", true);
                           
                           }
                           
                           );
    }
}

function initReportView(inputData) {
    var report = report_folder;
    if(inputData.type == "Country") {
        if (window.orientation == 90 || window.orientation == -90) {
            report += "Country Report.rptdesign"
        } else {
            report += "Country Report Portrait.rptdesign";
        }
    } else if(inputData.type == "Region") {
        if (window.orientation == 90 || window.orientation == -90) {
            report += "Regional Report.rptdesign"
        } else {
            report += "Regional Report Portrait.rptdesign";
        }
    } else if(inputData.type == "Continent") {
        if (window.orientation == 90 || window.orientation == -90) {
            report += "Continent Report.rptdesign"
        } else {
            report += "Continent Report Portrait.rptdesign";
        }
    } else {
        if (window.orientation == 90 || window.orientation == -90) {
            report += "World Report.rptdesign"
        } else {
            report += "World Report Portrait.rptdesign";
        }
    }
    
    document.getElementById('container').style.display="none";
    $("#report").css("margin-top" , "-25px");
    if (actuate && actuate.isInitialized()) {
        loadViewer(inputData, report, "report");
    } else {
        
        var reqOps = new actuate.RequestOptions( );
        //reqOps.setVolumeProfile( "default volume" );
        //reqOps.setVolume( "default volume" );
        actuate.load("viewer");
        actuate.initialize(
                           baseUrl,
                           //reqOps,
                           userName,
                           password,
                           function()
                           {
                           
                           loadViewer(inputData, report, "report");
                           
                           }
                           
                           );
    }
}


function loadViewer( data, report, id, bookmark)
{
    try
    {
        var viewer = new actuate.Viewer( id);
        viewer.setReportDesign( report );
        var options = new actuate.viewer.UIOptions( );
        options.enableToolBar(false);
        var parameterValues=[];
        
        if(data.continent != null) {
            var param=new actuate.viewer.impl.ParameterValue();
            param.setName("continent");
            param.setValue(data.continent);
            parameterValues.push(param);
        }
        
        if (data.region != null) {
            var param=new actuate.viewer.impl.ParameterValue();
            param.setName("region");
            param.setValue(data.region);
            parameterValues.push(param);
        }
        
        if (data.country != null) {
            var param=new actuate.viewer.impl.ParameterValue();
            param.setName("country");
            param.setValue(data.country);
            parameterValues.push(param);
        }
        
        
        if (parameterValues.length > 0 ) {
            viewer.setParameterValues(parameterValues);
        }
        
        if (bookmark) {
            if(window.orientation == 90 || window.orientation == -90){
                viewer.setReportletBookmark(data.type.toLowerCase() + "_landscape");
                viewer.setWidth(256);
                viewer.setHeight(528);
            } else {
                viewer.setReportletBookmark(data.type.toLowerCase() + "_portrait");
                viewer.setHeight(192);
                viewer.setWidth(576);
            }
        } else {
            viewer.setWidth(window.innerWidth);
            viewer.setHeight(window.innerHeight);
        }
        viewer.registerEventHandler(actuate.viewer.impl.EventConstants.ON_SESSION_TIMEOUT,
            function() {
                window.location = "js-call:timeOut";
            }
        );

        viewer.setUIOptions( options );
        viewer.submit();
    }
    catch( e )
    {
        //alert( e.getErrorMessage( ) );
    }
}
