import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:OilEnergy_System/API/daily.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/models/Dailys.dart';

class DailyBarChart extends StatefulWidget {
  DailyBarChart({super.key,});

  @override
  State<DailyBarChart> createState() => _DailyBarChartState();
}


class _DailyBarChartState extends State<DailyBarChart> {

  bool isLoading = false;
  String user = '';
  List<DailyData> daily_data = [];
  List data = [];

  @override
  void initState() {
    GetAllDaily();
    super.initState();
  }

  //server side function
  Future GetAllDaily () async{
    setState(() {
      isLoading = true;
    });

    //post to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Daily.Get_All_Daily(auth.token);

    setState(() {
      isLoading = false;
      data = response['daily_trans'];
      user = auth.user.username;
    });
  }


  @override
  Widget build(BuildContext context) {
    daily_data = data.map((d) => DailyData(dailyId: d['daily_id'], date: d['date'], amount: d['amount'], safe: d['safe'], createdAt: d['createdAt'], updatedAt: d['updatedAt'])).toList();

    return daily_data.length != 0 ? Container(
      height: 300,
        width: MediaQuery.of(context).size.width/2,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        ),
        color: Colors.grey[300],
        child: Padding(
          padding: EdgeInsets.only(top: 15),
          child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.start,
                  borderData: FlBorderData(
                      border: const Border(
                        top: BorderSide.none,
                        right: BorderSide.none,
                        left: BorderSide(width: 1),
                        bottom: BorderSide(width: 1),
                      )),
                  groupsSpace: 40,
                  barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(),

                    ),
                    barGroups: daily_data.map((daily) =>
                        BarChartGroupData(x: 1, barRods: [
                          BarChartRodData(toY: daily.amount.toDouble(), width: 17, color: Colors.amber),
                        ]),
                    ).toList()
                     )
          ),
            ),
          )
        ): Center(
              child: Container(
                  color: Colors.grey[200],
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: Text('لا يوجد يوميات '))),
    );
  }
}
