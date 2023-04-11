import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:untitled5/screens/heart_view.dart';

import '../utils/colors_manager.dart';

class Chart extends StatelessWidget {
  final List<SensorValue> _data;

  const Chart(this._data, {super.key});

  @override
  Widget build(BuildContext context) {
    return _data.isNotEmpty ? chartToRun() : Container();
  }

  Widget chartToRun() {
    List<double> values = <double>[];

    for (var element in _data) {
      if (element.value > 0) {
        values?.add(element.value);
      }
    }

    LabelLayoutStrategy? xContainerLabelLayoutStrategy;
    ChartData chartData;
    ChartOptions chartOptions = const ChartOptions();
    // Set chart options to show no labels
    chartOptions = const ChartOptions.noLabels();

    chartData = ChartData(
      dataRows: [values],
      xUserLabels: List.filled(values.length, "rate"),
      dataRowsLegends: const ['heart'],
      dataRowsColors: [ColorsManager.error],
      chartOptions: chartOptions,
    );
    var lineChartContainer = LineChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );

    var lineChart = Container(
      width: double.infinity,
      child: LineChart(
        painter: LineChartPainter(
          lineChartContainer: lineChartContainer,
        ),
      ),
    );
    return lineChart;
  }
}
