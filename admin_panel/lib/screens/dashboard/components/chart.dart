import 'package:admin_panel/utility/extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/data/data_provider.dart';
import '../../../utility/constants.dart';

class Chart extends StatelessWidget {
  const Chart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: _buildPieChartSelectionData(context),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding),
                Consumer<DataProvider>(
                  builder: (context, dataProvider, child) {
                    return Text(
                      '${context.dataProvider.calculateOrdersWithStatus()}',
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                height: 0.5,
                              ),
                    );
                  },
                ),
                const SizedBox(height: defaultPadding),
                const Text("Order")
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSelectionData(BuildContext context) {
    // final DataProvider dataProvider = Provider.of<DataProvider>(context);

    // int totalOrder = context.dataProvider.calculateOrdersWithStatus();
    int pendingOrder =
        context.dataProvider.calculateOrdersWithStatus(status: 'pending');
    int processingOrder =
        context.dataProvider.calculateOrdersWithStatus(status: 'processing');
    int cancelledOrder =
        context.dataProvider.calculateOrdersWithStatus(status: 'cancelled');
    int shippedOrder =
        context.dataProvider.calculateOrdersWithStatus(status: 'shipped');
    int deliveredOrder =
        context.dataProvider.calculateOrdersWithStatus(status: 'delivered');

    List<PieChartSectionData> pieChartSelectionData = [
      PieChartSectionData(
        color: const Color(0xFFFFCF26),
        value: pendingOrder.toDouble(),
        showTitle: false,
        radius: 20,
      ),
      PieChartSectionData(
        color: const Color(0xFFEE2727),
        value: cancelledOrder.toDouble(),
        showTitle: false,
        radius: 20,
      ),
      PieChartSectionData(
        color: const Color(0xFF2697FF),
        value: shippedOrder.toDouble(),
        showTitle: false,
        radius: 20,
      ),
      PieChartSectionData(
        color: const Color(0xFF26FF31),
        value: deliveredOrder.toDouble(),
        showTitle: false,
        radius: 20,
      ),
      PieChartSectionData(
        color: Colors.white,
        value: processingOrder.toDouble(),
        showTitle: false,
        radius: 20,
      ),
    ];

    return pieChartSelectionData;
  }
}
