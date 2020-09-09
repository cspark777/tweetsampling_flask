(function($) {
  "use strict"; // Start of use strict
    
    var d = new Date();
    var timeoffset = d.getTimezoneOffset() * 60000;

    am4core.useTheme(am4themes_animated);
    //am4core.useTheme(am4themes_dark);

    var data = [];
    
    var data_json = $("#init_chart_data").val();
    if(data_json != undefined)
    {
        var data_obj = JSON.parse(data_json);

        //========= for line chart =============

        var len = data_obj["line_chart_data"].length;
        for (var i=0; i<len; i++){
            data_obj["line_chart_data"][i]["date"] = data_obj["line_chart_data"][i]["date"] - timeoffset;
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
        //dateAxis_line.renderer.inside = true;

        var valueAxis_line = chart_line.yAxes.push(new am4charts.ValueAxis());
        valueAxis_line.tooltip.disabled = true;
        valueAxis_line.interpolationDuration = 500;
        valueAxis_line.rangeChangeDuration = 500;        
        valueAxis_line.renderer.minLabelPosition = 0.05;
        valueAxis_line.renderer.maxLabelPosition = 0.95;

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
        var timestamp_pie = pie_chart_data["date"] - timeoffset;
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
        var chart = am4core.create("chartdiv_map", am4maps.MapChart);


        try {
            chart.geodata = am4geodata_worldLow;
        }
        catch (e) {
            chart.raiseCriticalError(new Error("Map geodata could not be loaded. Please download the latest <a href=\"https://www.amcharts.com/download/download-v4/\">amcharts geodata</a> and extract its contents into the same directory as your amCharts files."));
        }


        chart.projection = new am4maps.projections.Miller();

        var title = chart.chartContainer.createChild(am4core.Label);
        title.text = "Life expectancy in the World";
        title.fontSize = 20;
        title.paddingTop = 30;
        title.align = "center";

        var polygonSeries = chart.series.push(new am4maps.MapPolygonSeries());
        var polygonTemplate = polygonSeries.mapPolygons.template;
        polygonTemplate.tooltipText = "{name}: {value.value}";
        polygonSeries.useGeodata = true;
        polygonSeries.heatRules.push({ property: "fill", target: polygonSeries.mapPolygons.template, min: am4core.color("#ffffff"), max: am4core.color("#AAAA00") });


        // add heat legend
        var heatLegend = chart.chartContainer.createChild(am4maps.HeatLegend);
        heatLegend.valign = "bottom";
        heatLegend.series = polygonSeries;
        heatLegend.width = am4core.percent(100);
        heatLegend.orientation = "horizontal";
        heatLegend.padding(30, 30, 30, 30);
        heatLegend.valueAxis.renderer.labels.template.fontSize = 10;
        heatLegend.valueAxis.renderer.minGridDistance = 40;

        polygonSeries.mapPolygons.template.events.on("over", function (event) {
          handleHover(event.target);
        })

        polygonSeries.mapPolygons.template.events.on("hit", function (event) {
          handleHover(event.target);
        })

        function handleHover(mapPolygon) {
          if (!isNaN(mapPolygon.dataItem.value)) {
            heatLegend.valueAxis.showTooltipAt(mapPolygon.dataItem.value)
          }
          else {
            heatLegend.valueAxis.hideTooltip();
          }
        }

        polygonSeries.mapPolygons.template.events.on("out", function (event) {
          heatLegend.valueAxis.hideTooltip();
        })


        // life expectancy data

        polygonSeries.data = [{ id: "AF", value: 60.524 },
        { id: "AL", value: 77.185 },
        { id: "DZ", value: 70.874 },
        { id: "AO", value: 51.498 },
        { id: "AR", value: 76.128 },
        { id: "AM", value: 74.469 },
        { id: "AU", value: 82.364 },
        { id: "AT", value: 80.965 },
        { id: "AZ", value: 70.686 },
        { id: "BH", value: 76.474 },
        { id: "BD", value: 70.258 },
        { id: "BY", value: 69.829 },
        { id: "BE", value: 80.373 },
        { id: "BJ", value: 59.165 },
        ];

        // excludes Antarctica
        polygonSeries.exclude = ["AQ"];

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


                })
                .fail(function(msg){
                    console.log(msg);          
                });
                
            }, 3000);
        }

        startInterval();
    }
 
})(jQuery); // End of use strict