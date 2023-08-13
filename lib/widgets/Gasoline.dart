import 'package:flutter/material.dart';
import 'package:oil_pump_system/API/gas.dart';
import 'package:oil_pump_system/SharedService.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:oil_pump_system/components/tables/gasoline_table.dart';
import 'package:sidebarx/sidebarx.dart';

class Gasolines extends StatefulWidget {
  const Gasolines({super.key});

  @override
  State<Gasolines> createState() => _GasolinesState();
}

class _GasolinesState extends State<Gasolines> {
  SidebarXController controller = SidebarXController(selectedIndex: 1, extended: true);

  bool isLoading = false;
  List data = [];
  int avail_benz = 0;
  int avail_gas = 0;

  @override
  void initState() {
    getAllGas();
    super.initState();
  }
  //server side Functions ------------------
  //------get--
  Future getAllGas () async {
    setState(() {
      isLoading = true;
    });
    //post to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Gas.Get_All_Gas(auth.token);

    response != false ?
    setState(() {
      isLoading = false;
      data = response['gas'];
      avail_benz = response['available_benz'];
      avail_gas = response['available_gas'];
    }) : setState(() {
      isLoading = false;
      data = [];
      avail_benz = 0;
      avail_gas = 0;
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
            Row(
              children: [
                Navbar(controller: controller),
              ],
            ),
            Expanded(
                child: ListView(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/Curve_Line.png'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.difference),
                          )
                      ),
                      child: Center(child: Text('حالة الوقود', style: TextStyle(fontSize: 26, color: Colors.white), textAlign: TextAlign.center,)),
                    ),
                    SizedBox(height: 80,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        data.length != 0?
                        Container(
                            color: Colors.grey.shade100,
                            child: Column(
                              children: [
                                GasolineTable(data: data,),
                                Padding(
                                  padding:  EdgeInsets.only(left: 40.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('متبقي بئر البنزين = $avail_benz لتر',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                                      ),
                                      SizedBox(width: 35,),
                                      Text('متبقي بئر الجازولين = $avail_gas لتر',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20,)
                              ],
                            )
                        ) : GasolineTable(data: data),
                      ],
                    ),
                    SizedBox(height: 50,),
                  ]
                )
            ) 
          ],
        ),
      ),
    );
  }
}
