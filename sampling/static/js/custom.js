(function($) {
  "use strict"; // Start of use strict
    
    var d = new Date();
    var timeoffset = 0; //d.getTimezoneOffset() * 60000;

    am4core.useTheme(am4themes_animated);
    //am4core.useTheme(am4themes_dark);
am4core.ready(function() {
    var data = [];
    
    var data_json = $("#init_chart_data").val();
    if(data_json != undefined)
    {
        var data_obj = JSON.parse(data_json);

        //========= for line chart =============

        var len = data_obj["line_chart_data"].length;
        for (var i=0; i<len; i++){
            data_obj["line_chart_data"][i]["date"] = data_obj["line_chart_data"][i]["date"];// + timeoffset;
        }

        var chart_line = am4core.create("chartdiv_line", am4charts.XYChart);
        chart_line.padding(0, 0, 0, 0);

        chart_line.zoomOutButton.disabled = true;
        chart_line.data = data_obj["line_chart_data"];


        var dateAxis_line = chart_line.xAxes.push(new am4charts.DateAxis());
        dateAxis_line.renderer.grid.template.location = 0;
        dateAxis_line.renderer.minGridDistance = 30;
        dateAxis_line.dateFormats.setKey("minute", "mm");        
        dateAxis_line.periodChangeDateFormats.setKey("minute", "[bold]h:mm a");
        dateAxis_line.periodChangeDateFormats.setKey("hour", "[bold]h:mm a");
        dateAxis_line.renderer.inside = true;

        var valueAxis_line = chart_line.yAxes.push(new am4charts.ValueAxis());
        valueAxis_line.tooltip.disabled = true;
        valueAxis_line.interpolationDuration = 500;
        valueAxis_line.rangeChangeDuration = 500;        
        valueAxis_line.renderer.minLabelPosition = 0.05;
        valueAxis_line.renderer.maxLabelPosition = 0.95;
        valueAxis_line.renderer.inside = true;
        /*
        var title_line = chart_line.titles.create();
        title_line.fontSize = "1.5em";
        title_line.text = "Tweet Realtime Line Chart";
        title_line.align = "left";
        title_line.horizontalCenter = "center";
        title_line.marginLeft = 20;
        title_line.paddingBottom = 10;
        title_line.fill = am4core.color("#000000");
        title_line.y = 20;
        */
        var series_negative = chart_line.series.push(new am4charts.LineSeries());
        series_negative.dataFields.dateX = "date";
        series_negative.dataFields.valueY = "negative";
        series_negative.interpolationDuration = 500;
        series_negative.defaultState.transitionDuration = 0;
        series_negative.tensionX = 0.8;
        series_negative.tooltipText = "{negative}"

        series_negative.fillOpacity = 0.5;
        // bullet at the front of the line
        var bullet_negative = series_negative.createChild(am4charts.CircleBullet);
        bullet_negative.circle.radius = 5;
        bullet_negative.fillOpacity = 1;
        bullet_negative.fill = chart_line.colors.getIndex(0);
        bullet_negative.isMeasured = false;

        series_negative.events.on("validated", function() {
            bullet_negative.moveTo(series_negative.dataItems.last.point);
            bullet_negative.validatePosition();
        });

        var series_neutral = chart_line.series.push(new am4charts.LineSeries());
        series_neutral.dataFields.dateX = "date";
        series_neutral.dataFields.valueY = "neutral";
        series_neutral.interpolationDuration = 500;
        series_neutral.defaultState.transitionDuration = 0;
        series_neutral.tensionX = 0.8;
        series_neutral.tooltipText = "{neutral}"

        series_neutral.fillOpacity = 0.5;
        // bullet at the front of the line
        var bullet_neutral = series_neutral.createChild(am4charts.CircleBullet);
        bullet_neutral.circle.radius = 5;
        bullet_neutral.fillOpacity = 1;
        bullet_neutral.fill = chart_line.colors.getIndex(1);
        bullet_neutral.isMeasured = false;

        series_neutral.events.on("validated", function() {
            bullet_neutral.moveTo(series_neutral.dataItems.last.point);
            bullet_neutral.validatePosition();
        });


        var series_positive = chart_line.series.push(new am4charts.LineSeries());
        series_positive.dataFields.dateX = "date";
        series_positive.dataFields.valueY = "positive";
        series_positive.interpolationDuration = 500;
        series_positive.defaultState.transitionDuration = 0;
        series_positive.tensionX = 0.8;
        series_positive.tooltipText = "{positive}"

        series_positive.fillOpacity = 0.5;
        // bullet at the front of the line
        var bullet_positive = series_positive.createChild(am4charts.CircleBullet);
        bullet_positive.circle.radius = 5;
        bullet_positive.fillOpacity = 1;
        bullet_positive.fill = chart_line.colors.getIndex(2);
        bullet_positive.isMeasured = false;

        series_positive.events.on("validated", function() {
            bullet_positive.moveTo(series_positive.dataItems.last.point);
            bullet_positive.validatePosition();
        });

        chart_line.events.on("datavalidated", function () {
            dateAxis_line.zoom({ start: 1 / 15, end: 1.2 }, false, true);
        });

        dateAxis_line.interpolationDuration = 500;
        dateAxis_line.rangeChangeDuration = 500;

        chart_line.cursor = new am4charts.XYCursor();
        chart_line.cursor.xAxis = dateAxis_line;


        //=============== for pie chart
       
        // Create chart instance
        var chart_pie = am4core.create("chartdiv_pie", am4charts.PieChart);
        var pie_chart_data = data_obj["pie_chart_data"]
        // Add data
        chart_pie.data = [
          { "polarity": "negative", "value": pie_chart_data["negative"] },
          { "polarity": "neutral", "value": pie_chart_data["neutral"] },
          { "polarity": "positive", "value": pie_chart_data["positive"] },          
        ];

        // Add label
        var timestamp_pie = pie_chart_data["date"];// + timeoffset;
        var label_date = new Date(timestamp_pie)
        var hour = label_date.getHours();
        var hour_str = hour.toString();
        if(hour<10) hour_str = "0" + hour_str;
        var min = label_date.getMinutes();
        var min_str = min.toString();
        if(min<10) min_str = "0" + min_str;

        var label_string = hour_str + ":" + min_str;


        chart_pie.innerRadius = 100;
        var label_pie = chart_pie.seriesContainer.createChild(am4core.Label);
        label_pie.text = label_string;
        label_pie.horizontalCenter = "middle";
        label_pie.verticalCenter = "middle";
        label_pie.fontSize = 50;

        // Add and configure Series
        var pieSeries = chart_pie.series.push(new am4charts.PieSeries());
        pieSeries.dataFields.value = "value";
        pieSeries.dataFields.category = "polarity";

        //====== for bar chart
        var chart_bar = am4core.create("chartdiv_bar", am4charts.XYChart);
        var bar_chart_data = data_obj["bar_chart_data"]
        chart_bar.data = bar_chart_data;

        chart_bar.padding(40, 40, 40, 40);

        var categoryAxis_bar = chart_bar.yAxes.push(new am4charts.CategoryAxis());
        categoryAxis_bar.renderer.grid.template.location = 0;
        categoryAxis_bar.dataFields.category = "country";
        categoryAxis_bar.renderer.minGridDistance = 1;
        categoryAxis_bar.renderer.inversed = true;
        categoryAxis_bar.renderer.grid.template.disabled = true;

        var valueAxis_bar = chart_bar.xAxes.push(new am4charts.ValueAxis());
        valueAxis_bar.min = 0;        

        
        //valueAxis_bar.rangeChangeEasing = am4core.ease.linear;
        //valueAxis_bar.rangeChangeDuration = 1500;

        var series_bar = chart_bar.series.push(new am4charts.ColumnSeries());
        series_bar.dataFields.categoryY = "country";
        series_bar.dataFields.valueX = "value";
        series_bar.tooltipText = "{valueX.value}"
        series_bar.columns.template.strokeOpacity = 0;
        series_bar.columns.template.column.cornerRadiusBottomRight = 5;
        series_bar.columns.template.column.cornerRadiusTopRight = 5;
        //series_bar.interpolationDuration = 1500;
        //series_bar.interpolationEasing = am4core.ease.linear;
        var labelBullet = series_bar.bullets.push(new am4charts.LabelBullet())
        labelBullet.label.horizontalCenter = "left";
        labelBullet.label.dx = 10;
        labelBullet.label.text = "{values.valueX.workingValue}";
        labelBullet.locationX = 1;

        chart_bar.zoomOutButton.disabled = true;

        // as by default columns of the same series are of the same color, we add adapter which takes colors from chart.colors color set
        series_bar.columns.template.adapter.add("fill", function (fill, target) {
            return chart_bar.colors.getIndex(target.dataItem.index);
        });
        
        categoryAxis_bar.sortBySeries = series_bar;

        //===== for world map chart
        var circleColor = am4core.color("#45d21a");
        var countryColor = am4core.color("#3b3b3b");
        var countryStrokeColor = am4core.color("#000000");
        var countryHoverColor = am4core.color("#1b1b1b");
        var activeCountryColor = am4core.color("#0f0f0f");
        var currentCountry = "World";
        var currentPolygon;

        var world_chart_data = data_obj["world_chart_data"]

        // as we will be modifying raw data, make a copy
        var mapData = JSON.parse(JSON.stringify(world_chart_data));

        // remove items with 0 values for better performance
        for(var i = mapData.length - 1; i >= 0; i--){
            if(mapData[i].value == 0){
                mapData.splice(i, 1);
            }
        }

        // main container
        // https://www.amcharts.com/docs/v4/concepts/svg-engine/containers/
        var container = am4core.create("chartdiv_map", am4core.Container);
        container.width = am4core.percent(100);
        container.height = am4core.percent(100);

        container.tooltip = new am4core.Tooltip();  
        container.tooltip.background.fill = am4core.color("#000000");
        container.tooltip.background.stroke = circleColor;
        container.tooltip.fontSize = "0.9em";
        container.tooltip.getFillFromObject = false;
        container.tooltip.getStrokeFromObject = false;

        // MAP CHART 
        // https://www.amcharts.com/docs/v4/chart-types/map/
        var mapChart = container.createChild(am4maps.MapChart);
        mapChart.height = am4core.percent(100);
        mapChart.zoomControl = new am4maps.ZoomControl();
        mapChart.zoomControl.align = "right";
        mapChart.zoomControl.marginRight = 15;
        mapChart.zoomControl.valign = "middle";
        mapChart.homeGeoPoint = { longitude: 0, latitude: -2 };

        // by default minus button zooms out by one step, but we modify the behavior so when user clicks on minus, the map would fully zoom-out and show world data
        mapChart.zoomControl.minusButton.events.on("hit", showWorld);
        // clicking on a "sea" will also result a full zoom-out
        mapChart.seriesContainer.background.events.on("hit", showWorld);
        mapChart.seriesContainer.background.events.on("over", resetHover);
        mapChart.seriesContainer.background.fillOpacity = 0;
        mapChart.zoomEasing = am4core.ease.sinOut;

        // https://www.amcharts.com/docs/v4/chart-types/map/#Map_data
        // you can use more accurate world map or map of any other country - a wide selection of maps available at: https://github.com/amcharts/amcharts4-geodata
        mapChart.geodata = am4geodata_worldLow;

        // Set projection
        // https://www.amcharts.com/docs/v4/chart-types/map/#Setting_projection
        // instead of Miller, you can use Mercator or many other projections available: https://www.amcharts.com/demos/map-using-d3-projections/
        mapChart.projection = new am4maps.projections.Miller();
        mapChart.panBehavior = "move";

        // when map is globe, beackground is made visible
        mapChart.backgroundSeries.mapPolygons.template.polygon.fillOpacity = 0.05;
        mapChart.backgroundSeries.mapPolygons.template.polygon.fill = am4core.color("#ffffff");
        mapChart.backgroundSeries.hidden = true;


        // Map polygon series (defines how country areas look and behave)
        var polygonSeries = mapChart.series.push(new am4maps.MapPolygonSeries());
        polygonSeries.dataFields.id = "id";
        polygonSeries.dataFields.value = "valuePC";
        polygonSeries.interpolationDuration = 0;

        polygonSeries.exclude = ["AQ"]; // Antarctica is excluded in non-globe projection
        polygonSeries.useGeodata = true;
        polygonSeries.nonScalingStroke = true;
        polygonSeries.strokeWidth = 0.5;
        // this helps to place bubbles in the visual middle of the area
        polygonSeries.calculateVisualCenter = true;
        polygonSeries.data = mapData;

        var polygonTemplate = polygonSeries.mapPolygons.template;
        polygonTemplate.fill = countryColor;
        polygonTemplate.fillOpacity = 1
        polygonTemplate.stroke = countryStrokeColor;
        polygonTemplate.strokeOpacity = 0.15
        polygonTemplate.setStateOnChildren = true;
        polygonTemplate.tooltipPosition = "fixed";

        polygonTemplate.events.on("over", handleCountryOver);
        polygonTemplate.events.on("out", handleCountryOut);


        polygonSeries.heatRules.push({
            "target": polygonTemplate,
            "property": "fill",
            "min": countryColor,
            "max": countryColor,
            "dataField": "value"
        })

        // you can have pacific - centered map if you set this to -154.8
        mapChart.deltaLongitude = -10;

        // polygon states
        var polygonHoverState = polygonTemplate.states.create("hover");
        polygonHoverState.transitionDuration = 1400;
        polygonHoverState.properties.fill = countryHoverColor;

        var polygonActiveState = polygonTemplate.states.create("active")
        polygonActiveState.properties.fill = activeCountryColor;

        // Bubble series
        var bubbleSeries = mapChart.series.push(new am4maps.MapImageSeries());  
        bubbleSeries.data = JSON.parse(JSON.stringify(mapData));

        bubbleSeries.dataFields.value = "value";
        bubbleSeries.dataFields.id = "id";

        // adjust tooltip
        bubbleSeries.tooltip.animationDuration = 0;
        bubbleSeries.tooltip.showInViewport = false;
        bubbleSeries.tooltip.background.fillOpacity = 0.2;
        bubbleSeries.tooltip.getStrokeFromObject = true;
        bubbleSeries.tooltip.getFillFromObject = false;
        bubbleSeries.tooltip.background.fillOpacity = 0.2;
        bubbleSeries.tooltip.background.fill = am4core.color("#000000");

        var imageTemplate = bubbleSeries.mapImages.template;
        // if you want bubbles to become bigger when zoomed, set this to false
        imageTemplate.nonScaling = true;
        imageTemplate.strokeOpacity = 0;
        imageTemplate.fillOpacity = 0.55;
        imageTemplate.tooltipText = "{name}: [bold]{value}[/]";
        imageTemplate.applyOnClones = true;

        imageTemplate.events.on("over", handleImageOver);
        imageTemplate.events.on("out", handleImageOut);

        // this is needed for the tooltip to point to the top of the circle instead of the middle
        imageTemplate.adapter.add("tooltipY", function(tooltipY, target) {
            return -target.children.getIndex(0).radius;
        })

        // When hovered, circles become non-opaque  
        var imageHoverState = imageTemplate.states.create("hover");
        imageHoverState.properties.fillOpacity = 1;

        // add circle inside the image
        var circle = imageTemplate.createChild(am4core.Circle);
        // this makes the circle to pulsate a bit when showing it
        circle.hiddenState.properties.scale = 0.0001;
        circle.hiddenState.transitionDuration = 2000;
        circle.defaultState.transitionDuration = 2000;
        circle.defaultState.transitionEasing = am4core.ease.elasticOut;
        // later we set fill color on template (when changing what type of data the map should show) and all the clones get the color because of this
        circle.applyOnClones = true;

        // heat rule makes the bubbles to be of a different width. Adjust min/max for smaller/bigger radius of a bubble
        bubbleSeries.heatRules.push({
            "target": circle,
            "property": "radius",
            "min": 3,
            "max": 15,
            "dataField": "value"
        })

        // when data items validated, hide 0 value bubbles (because min size is set)
        bubbleSeries.events.on("dataitemsvalidated", function() {
            bubbleSeries.dataItems.each((dataItem) => {
                var mapImage = dataItem.mapImage;
                var circle = mapImage.children.getIndex(0);
                if (mapImage.dataItem.value == 0) {
                    circle.hide(0);
                }
                else if (circle.isHidden || circle.isHiding) {
                    circle.show();
                }
            })
        })

        // setting colors on mapImage for tooltip colors
        bubbleSeries.mapImages.template.fill = circleColor
        bubbleSeries.mapImages.template.stroke = circleColor
        // first child is circle
        bubbleSeries.mapImages.template.children.getIndex(0).fill = circleColor

        // this places bubbles at the visual center of a country
        imageTemplate.adapter.add("latitude", function(latitude, target) {
        var polygon = polygonSeries.getPolygonById(target.dataItem.id);
            if (polygon) {
                target.disabled = false;
                return polygon.visualLatitude;
            }
            else {
                target.disabled = true;
            }
            return latitude;
        })

        imageTemplate.adapter.add("longitude", function(longitude, target) {
        var polygon = polygonSeries.getPolygonById(target.dataItem.id);
            if (polygon) {
                target.disabled = false;
                return polygon.visualLongitude;
            }
            else {
                target.disabled = true;
            }
            return longitude;
        })

        // END OF MAP  

        // what happens when a country is rolled-over
        function rollOverCountry(mapPolygon) {

            resetHover();
            if (mapPolygon) {
                mapPolygon.isHover = true;

                // make bubble hovered too
                var image = bubbleSeries.getImageById(mapPolygon.dataItem.id);
                if (image) {
                    image.dataItem.dataContext.name = mapPolygon.dataItem.dataContext.name;
                    image.isHover = true;
                }
            }
        }
        // what happens when a country is rolled-out
        function rollOutCountry(mapPolygon) {
            var image = bubbleSeries.getImageById(mapPolygon.dataItem.id)

            resetHover();
                if (image) {
                    image.isHover = false;
                }
        }

        // show world data
        function showWorld() {
            currentCountry = "World";
            currentPolygon = undefined;
            resetHover();

            // make all inactive
            polygonSeries.mapPolygons.each(function(polygon) {
                polygon.isActive = false;
            })

            mapChart.goHome();
        }

        function handleImageOver(event) {
            rollOverCountry(polygonSeries.getPolygonById(event.target.dataItem.id));
        }

        function handleImageOut(event) {
            rollOutCountry(polygonSeries.getPolygonById(event.target.dataItem.id));
        }

        function handleCountryOver(event) {
            rollOverCountry(event.target);
        }

        function handleCountryOut(event) {
            rollOutCountry(event.target);
        }

        function resetHover() {
            polygonSeries.mapPolygons.each(function(polygon) {
                polygon.isHover = false;
            })

            bubbleSeries.mapImages.each(function(image) {
                image.isHover = false;
            })
        }

        function updateMapData(data) {
            //modifying instead of setting new data for a nice animation
            bubbleSeries.dataItems.each(function(dataItem) {
                dataItem.dataContext.value = 0;        
            })            

            for (var i = 0; i < data.length; i++) {
                var di = data[i];
                var image = bubbleSeries.getImageById(di.id);
                var polygon = polygonSeries.getPolygonById(di.id);

                if (image) {                    
                    image.dataItem.dataContext.value = di.value;
                }

                if (polygon) {                
                    polygon.dataItem.dataContext.valuePC = di.value;                
                }

                bubbleSeries.invalidateRawData();
                polygonSeries.invalidateRawData();
            }
        }

        //===========================

        document.addEventListener("visibilitychange", function() {
            if (document.hidden) {
                if (interval) {
                    clearInterval(interval);
                }
            }
            else {
                startInterval();
            }
        }, false);        

        // add data
        var interval;
        function startInterval() {
            interval = setInterval(function() {                
                var lastdataItem = series_neutral.dataItems.getIndex(series_neutral.dataItems.length - 1);
                var next_time = lastdataItem._dataContext["date"] + 60 * 1000 + timeoffset;

                $.ajax({
                    method: "POST",
                    url: "/chart_data",
                    data:{"next_time": next_time}
                })
                .done(function(msg) {      
                    var line_chart_data = msg["line_chart_data"];                   

                    chart_line.addData({ date: line_chart_data["date"] - timeoffset, negative: msg["line_chart_data"]["negative"], neutral: msg["line_chart_data"]["neutral"], positive: msg["line_chart_data"]["positive"] }, 1);

                    var pie_chart_data = msg["pie_chart_data"];
                    chart_pie.data[0]["polarity"] = "negative";
                    chart_pie.data[0]["value"] = pie_chart_data["negative"];
                    chart_pie.data[1]["polarity"] = "neutral";
                    chart_pie.data[1]["value"] = pie_chart_data["neutral"];
                    chart_pie.data[2]["polarity"] = "positive";
                    chart_pie.data[2]["value"] = pie_chart_data["positive"];
                    
                    timestamp_pie = pie_chart_data["date"] - timeoffset;
                    label_date = new Date(timestamp_pie)
                    hour = label_date.getHours();
                    hour_str = hour.toString();
                    if(hour<10) hour_str = "0" + hour_str;
                    min = label_date.getMinutes();
                    min_str = min.toString();
                    if(min<10) min_str = "0" + min_str;

                    label_string = hour_str + ":" + min_str;
                    label_pie.text = label_string;
                    chart_pie.invalidateRawData();

                    var bar_chart_data = msg["bar_chart_data"];
                    chart_bar.data = bar_chart_data;
                    chart_pie.invalidateRawData();

                    var world_chart_data = msg["world_chart_data"];
                    updateMapData(world_chart_data);
                })
                .fail(function(msg){
                    console.log(msg);          
                });
                
            }, 60000);
        }

        startInterval();
    }

});
 
})(jQuery); // End of use strict