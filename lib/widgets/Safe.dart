import 'package:OilEnergy_System/API/daily.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class Safe extends StatefulWidget {
  const Safe({super.key});

  @override
  State<Safe> createState() => _SafeState();
}

class _SafeState extends State<Safe> {
  SidebarXController controller = SidebarXController(selectedIndex: 8, extended: true);
  int total = 0;
  bool isLoading = false;
  DateTime date = DateTime.now();

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
    datas['date'] = date.toIso8601String();

    final auth = await SharedServices.LoginDetails();
    final response = await API_Daily.Get_Daily(datas, auth.token);

    setState(() {
      // isLoading = false;
      // trans_data = response['daily_trans'][0]['transactions'];
      // outg_data = response['daily_trans'][0]['outgoings'];
      total = response['daily_trans'][0]['safe'];
      // daily_id = response['daily_trans'][0]['daily_id'];
      // safe_append = response['daily_trans'][0]['safe'];
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
                Navbar(controller: controller,),
                Expanded(
                    child: Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('اجمالي الخزنة', style: TextStyle(fontSize: 28, color: Colors.black),),
                            Container(
                                    decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                        color: Colors.white
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text('$total', style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),),
                                  )),
                            ],
                          ),
                      ),
                    ))
              ],
            )
      ),
    );
  }
}
