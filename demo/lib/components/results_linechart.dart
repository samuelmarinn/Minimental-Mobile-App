import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class Series {
  final DateTime date;
  final int points;

  Series(
    { required this.date, required this.points
    }
  );
}

class Chart extends StatelessWidget {
  final List<Series> data;
  final String title;

  Chart({required this.data,required this.title});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<Series, DateTime>> series = [
      charts.Series(
        id: "points",
        data: data,
        domainFn: (Series series, _) => series.date,
        measureFn: (Series series, _) => series.points,
      )
    ];
    return Container(
      height: 200,
      padding: EdgeInsets.all(25),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Expanded(
                child: charts.TimeSeriesChart(series, animate: true,
                    domainAxis: const charts.DateTimeAxisSpec(
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}



