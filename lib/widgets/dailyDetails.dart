import 'package:flutter/material.dart';
import 'package:oil_pump_system/API/daily.dart';
import 'package:oil_pump_system/SharedService.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/outgoings.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:oil_pump_system/components/tables/daily_table.dart';
import 'package:sidebarx/sidebarx.dart';

class DailyDetails extends StatefulWidget {
  var date;
  DailyDetails({super.key, required this.date});

  @override
  State<DailyDetails> createState() => _DailyDetailsState(date: date);
}

class _DailyDetailsState extends State<DailyDetails> {
  var date;
  _DailyDetailsState({required this.date});

  SidebarXController controller = SidebarXController(selectedIndex: 0, extended: true);
  bool isLoading = false;
  List trans_data = [];
  List outg_data = [];
  int total  = 0;
  int total_count = 0;

  @override
  void initState() {
    GetDaily(date);
    super.initState();
  }
  //server side function
  Future GetDaily (date) async{
    setState(() {
       isLoading = true;
    });

    //post to server
    Map datas = {};
    datas['date'] = date;

    final auth = await SharedServices.LoginDetails();
    final response = await API_Daily.Get_Daily(datas, auth.token);

    setState(() {
      isLoading = false;
      trans_data = response['daily_trans'][0]['transactions'];
      outg_data = response['daily_trans'][0]['outgoings'];
      total = response['daily_trans'][0]['amount'];
      // total_outgs = response['total'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APPBAR(context),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Navbar(controller: controller),
            Expanded(
                child: ListView(
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 40,),
                        trans_data.length != 0 ?
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('التاريخ : $date', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                Text(' المبلغ الكلي : $total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                              ],
                            ),
                            SizedBox(height: 30,),
                            Container(
                                color: Colors.grey[100],
                                child: DailyTable(total: total_count ,daily_data: trans_data,)
                            ),
                            SizedBox(height: 30,),
                            Outgoings(total: total_count, data: outg_data,)
                          ],
                        )
                            : Center(
                            child: Container(
                                width: 280,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child: Center(
                                    child: Text('لا يوجد يومية في هذا اليوم',textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.white),)
                                )
                            )
                        )
                      ],
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
