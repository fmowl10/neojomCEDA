import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:neojom_ceda/provider/neojom_ceda_provider.dart';

class PollResultComponent extends StatelessWidget {
  const PollResultComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final pollResult = context.watch<NeojomCEDAProvider>().pollResult;
    final dataMap = {
      "찬성": pollResult.positive.toDouble(),
      "반대": pollResult.negative.toDouble()
    };
    final String resultMessage = pollResult.positive > pollResult.negative
        ? "찬성 승리"
        : pollResult.positive == pollResult.negative
            ? "무승부"
            : "반대 승리";
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.deepPurple)),
        child: Column(
          children: [
            PieChart(
              dataMap: dataMap,
              colorList: const [Colors.blueAccent, Colors.redAccent],
            ),
            Text(resultMessage)
          ],
        ));
  }
}
